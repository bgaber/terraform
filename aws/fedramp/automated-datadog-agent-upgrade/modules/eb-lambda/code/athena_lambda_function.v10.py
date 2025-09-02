import boto3
import time
import os
import logging
import requests
from datetime import datetime, timedelta

# Configure logging for CloudWatch
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Fetch environment variables
AWS_REGION = os.environ["AWS_REGION"]
DATABASE_NAME = os.environ["DATABASE_NAME"]
TABLE_NAME = os.environ["TABLE_NAME"]
S3_OUTPUT = os.environ["S3_OUTPUT"]
SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]
S3_BUCKET = os.environ["S3_BUCKET"]
S3_KEY = os.environ["S3_KEY"]
DD_SITE = os.environ.get("DD_SITE", "datadoghq.com")
MUTE_ENABLED = os.environ["MUTE_ENABLED"]
MUTE_DURATION_IN_SECS = os.environ["MUTE_DURATION_IN_SECS"]

# SSM Document Names
LINUX_SSM_DOCUMENT_NAME = os.environ.get("LINUX_SSM_DOCUMENT_NAME", "arn:aws:ssm:us-east-1:980921753767:document/Install-Datadog-Agent-Linux")
WINDOWS_SSM_DOCUMENT_NAME = os.environ.get("WINDOWS_SSM_DOCUMENT_NAME", "arn:aws:ssm:us-east-1:980921753767:document/Install-Datadog-Agent-Windows")

# AWS Accounts Lambda IAM Assume Role Name
ROLE_NAME = "FedRAMPSSMExecutionRole"

# Initialize AWS clients
athena_client = boto3.client("athena", region_name=AWS_REGION)
s3_client     = boto3.client("s3", region_name=AWS_REGION)
sns_client    = boto3.client("sns", region_name=AWS_REGION)
ssm_client    = boto3.client("ssm", region_name=AWS_REGION)
# ec2_client    = boto3.client("ec2", region_name=AWS_REGION)

def get_account_list(parameter_name):
    """Fetch a StringList parameter from SSM and return as a Python list."""
    response = ssm_client.get_parameter(Name=parameter_name, WithDecryption=False)
    value = response["Parameter"]["Value"]
    # SSM StringList returns a comma-separated string, so split it
    return value.split(",") if value else []

# AWS Accounts
TARGET_ACCOUNTS = get_account_list("/automated_agent_installation/penultimate_accounts")
TEST_ACCOUNTS   = get_account_list("/automated_agent_installation/latest_accounts")

def get_param_store_value(param_name, region_name=AWS_REGION):
    ssm_client = boto3.client("ssm", region_name=region_name)
    try:
        response = ssm_client.get_parameter(
            Name=param_name,
            WithDecryption=True
        )
        return response["Parameter"]["Value"]
    except ssm_client.exceptions.ParameterNotFound:
        logger.error(f"Parameter not found: {param_name} in region {region_name}")
        return None

DD_API_KEY         = get_param_store_value("DATADOG_API_KEY")
DD_APPLICATION_KEY = get_param_store_value("DATADOG_APP_KEY")

DATADOG_API_URL = f"https://api.{DD_SITE}/api/v1/downtime"
HEADERS = {"Content-Type": "application/json", "DD-API-KEY": DD_API_KEY, "DD-APPLICATION-KEY": DD_APPLICATION_KEY}


def get_assumed_client(svc, account_id, role_name, region):
    """Assume a role in another account and return an SSM client."""
    logger.info(f"get_assumed_client() function called with these parameters: {svc}, {account_id}, {role_name} and {region}")
    sts_client = boto3.client("sts")
    role_arn = f"arn:aws:iam::{account_id}:role/{role_name}"
    response = sts_client.assume_role(
        RoleArn=role_arn,
        RoleSessionName="LambdaCrossAccountSession"
    )
    creds = response["Credentials"]
    return boto3.client(
        svc,
        region_name=region,
        aws_access_key_id=creds["AccessKeyId"],
        aws_secret_access_key=creds["SecretAccessKey"],
        aws_session_token=creds["SessionToken"]
    )

def query_athena():
    """Query Athena for the latest and penultimate approved versions."""
    query = f"""
    SELECT Version, Approved
    FROM {DATABASE_NAME}.{TABLE_NAME}
    ORDER BY CAST(SPLIT(Version, '.')[1] AS INT) DESC,
             CAST(SPLIT(Version, '.')[2] AS INT) DESC
    LIMIT 2
    """

    response = athena_client.start_query_execution(
        QueryString=query,
        QueryExecutionContext={"Database": DATABASE_NAME},
        ResultConfiguration={"OutputLocation": S3_OUTPUT}
    )

    query_execution_id = response["QueryExecutionId"]

    # Wait for query completion
    while True:
        status_response = athena_client.get_query_execution(QueryExecutionId=query_execution_id)
        status = status_response["QueryExecution"]["Status"]["State"]

        if status in ["SUCCEEDED", "FAILED", "CANCELLED"]:
            break
        time.sleep(1)

    if status != "SUCCEEDED":
        logger.error(f"Athena query failed with status: {status}")
        raise Exception(f"Athena query failed with status: {status}")

    # Retrieve query results
    results = athena_client.get_query_results(QueryExecutionId=query_execution_id)
    rows = results.get("ResultSet", {}).get("Rows", [])

    if len(rows) > 1:
        latest_version = rows[1]["Data"][0]["VarCharValue"]
        latest_approved = rows[1]["Data"][1]["VarCharValue"]
        
        penultimate_version = rows[2]["Data"][0]["VarCharValue"] if len(rows) > 2 else None
        logger.info(f"Latest approved version: {latest_version}, Penultimate version: {penultimate_version}")
        return latest_version, penultimate_version, latest_approved

    logger.warning("No approved versions found in Athena query.")
    return None, None, "No result found"

def get_instances_by_tag(account_id, tag_key, tag_value):
    """Get EC2 instances and their OS types based on tag key-value pairs."""
    response = ec2_client.describe_instances(
        Filters=[
            {"Name": f"tag:{tag_key}", "Values": [tag_value]},
            {"Name": f"instance-state-name", "Values": ["running"]}
        ]
    )

    instances = []
    for reservation in response["Reservations"]:
        for instance in reservation["Instances"]:
            tag_keys = {tag["Key"] for tag in instance.get("Tags", [])}
            # Skip instance if any tag starts with "kubernetes.io/cluster/"
            if any(key.startswith("kubernetes.io/cluster/") for key in tag_keys):
                continue

            instance_id = instance["InstanceId"]
            platform = instance.get("Platform", "Linux")  # Defaults to "Linux" if not Windows
            instances.append({"InstanceId": instance_id, "OS": platform})
    
    logger.info(f"Instances in Account {account_id} with tag key of {tag_key}: {instances}")
    return instances

def create_datadog_downtime(instance_ids):
    """Create a Datadog downtime to mute monitoring."""
    try:
        payload = {
            "scope": [f"instance-id:{instance}" for instance in instance_ids],
            "message": "Muting during Datadog agent upgrade",
            "start": int(time.time()),
            "end": int(time.time()) + int(MUTE_DURATION_IN_SECS),  # 20 seconds
        }
        response = requests.post(DATADOG_API_URL, json=payload, headers=HEADERS)
        response.raise_for_status()
        downtime_id = response.json().get("id")
        logger.info(f"Datadog monitoring muted (downtime ID: {downtime_id}) for instances: {instance_ids}")
        return downtime_id
    except requests.exceptions.RequestException as e:
        logger.error(f"Failed to mute Datadog monitoring: {e}")
        return None

def remove_datadog_downtime(downtime_id):
    """Remove Datadog downtime after upgrade."""
    try:
        response = requests.delete(f"{DATADOG_API_URL}/{downtime_id}", headers=HEADERS)
        response.raise_for_status()
        logger.info(f"Datadog monitoring unmuted (downtime ID: {downtime_id})")
    except requests.exceptions.RequestException as e:
        logger.error(f"Failed to unmute Datadog monitoring: {e}")

def send_ssm_command_cross_account(account_ids, role_name, region, version):
    """Send an SSM command to update Datadog agent on instances with the correct document per OS."""
    global ssm_client
    global ec2_client

    for account_id in account_ids:
        logger.info(f"AWS Account being processed: {account_id}")
        if account_id == boto3.client("sts").get_caller_identity()["Account"]:
            # Use local client for the prime account
            logger.info(f"Prime Account being processed: {account_id}")
            ssm_client = boto3.client("ssm", region)
            ec2_client = boto3.client("ec2", region)
        else:
            logger.info(f"Other Account being processed: {account_id}")
            ssm_client = get_assumed_client("ssm", account_id, role_name, region)
            ec2_client = get_assumed_client("ec2", account_id, role_name, region)

        instances = get_instances_by_tag(account_id, "datadog", "true")
        if not instances:
            logger.warning(f"No instances found with tag key of 'datadog' set to 'true' in account {account_id}. Skipping SSM command.")
            continue

        if MUTE_ENABLED:
            downtime_id = create_datadog_downtime(instances)

        # Separate instances by OS type
        linux_instances = [i["InstanceId"] for i in instances if i["OS"].lower() == "linux"]
        windows_instances = [i["InstanceId"] for i in instances if i["OS"].lower() == "windows"]

        if not linux_instances and not windows_instances:
            logger.warning("No instances found for Linux or Windows. Skipping SSM execution.")
            continue

        # Correctly extract agentmajorversion and agentminorversion
        version_parts = version.split(".", 1)  # Split only on the first period
        agentmajorversion = version_parts[0]   # First part is the major version
        agentminorversion = version_parts[1] if len(version_parts) > 1 else "0"  # Rest is the minor version

        logger.debug(f"Parameters: version {version}, agentmajorversion {agentmajorversion}, agentminorversion {agentminorversion}")

        # Get Windows Document Parameters
        response = ssm_client.describe_document(Name=WINDOWS_SSM_DOCUMENT_NAME)
        logger.info(f"DEBUG SSM Document Parameters: {response["Document"]["Parameters"]}")

        def execute_ssm(instances, ssm_document):
            """Helper function to send the SSM command."""
            response = ssm_client.send_command(
                DocumentName=ssm_document,
                InstanceIds=instances,
                Parameters={
                    "action": ["Install"],
                    "apikey": [DD_API_KEY],
                    "hostname": [DD_SITE],
                    "agentmajorversion": [agentmajorversion],
                    "agentminorversion": [agentminorversion],
                }
            )
            command_id = response["Command"]["CommandId"]
            logger.info(f"SSM Command triggered in account {account_id}, for {ssm_document}. Command ID: {command_id}")

        # Execute for Linux instances
        if linux_instances:
            execute_ssm(linux_instances, LINUX_SSM_DOCUMENT_NAME)

        # Execute for Windows instances
        if windows_instances:
            execute_ssm(windows_instances, WINDOWS_SSM_DOCUMENT_NAME)

        # Remove Datadog downtime after upgrade
        if downtime_id:
            time.sleep(int(MUTE_DURATION_IN_SECS))  # The Lambda function times out with time greater than this
            remove_datadog_downtime(downtime_id)

def check_file_age():
    """Check if the CSV file is older than 30 days."""
    try:
        response = s3_client.head_object(Bucket=S3_BUCKET, Key=S3_KEY)
        last_modified = response['LastModified']
        age = datetime.now(last_modified.tzinfo) - last_modified
        is_old = age > timedelta(days=30)
        logger.info(f"File {S3_KEY} last modified {last_modified}, older than 30 days: {is_old}")
        return is_old
    except Exception as e:
        logger.error(f"Error checking S3 file age: {e}")
        return True  # Assume it's old if there's an error

# SNS topic needs email address
def send_sns_notification():
    """Send an SNS notification if the CSV file is older than 30 days."""
    message = f"The {S3_KEY} file is more than 30 days old and needs to be updated."
    sns_client.publish(TopicArn=SNS_TOPIC_ARN, Message=message)
    logger.info(f"SNS notification sent: {message}")

def lambda_handler(event, context):
    """Main Lambda function execution."""
    logger.info(f"Version 1.2.0")
    # Get the latest and penultimate versions and approval status
    latest_version, penultimate_version, approved_status = query_athena()

    # If the latest version is approved, execute SSM commands for both latest and penultimate versions
    if approved_status == "Yes":
        logger.info(f"Datadog Agent Version {latest_version} is approved. Triggering SSM updates.")
        # This should only run in the account where new versions of the agent are tested and validated
        send_ssm_command_cross_account(TEST_ACCOUNTS, ROLE_NAME, AWS_REGION, latest_version)

        if penultimate_version:
            logger.info(f"Triggering SSM update for penultimate version {penultimate_version}.")
            send_ssm_command_cross_account(TARGET_ACCOUNTS, ROLE_NAME, AWS_REGION, penultimate_version)
    else:
        logger.info(f"Datadog Agent Version {latest_version} is NOT approved. Skipping SSM update.")

        # Check if it's the first day of the month and if file is older than 30 days
        if datetime.now().day == 1:
            if check_file_age():
                logger.info("CSV file is older than 30 days. Sending SNS notification.")
                send_sns_notification()
    
    return {"message": f"The approval status of version {latest_version} is {approved_status}"}
