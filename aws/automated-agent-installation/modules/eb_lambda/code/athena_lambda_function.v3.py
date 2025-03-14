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
DD_API_KEY = os.environ["DD_API_KEY"]
DD_SITE = os.environ.get("DD_SITE", "datadoghq.com")
SSM_DOCUMENT_NAME = os.environ.get("SSM_DOCUMENT_NAME", "arn:aws:ssm:us-east-1:805960120419:document/automated-datadog-agent-upgrade")

# Initialize AWS clients
athena_client = boto3.client("athena", region_name=AWS_REGION)
s3_client = boto3.client("s3", region_name=AWS_REGION)
sns_client = boto3.client("sns", region_name=AWS_REGION)
ssm_client = boto3.client("ssm", region_name=AWS_REGION)
ec2_client = boto3.client("ec2", region_name=AWS_REGION)

DATADOG_API_URL = f"https://api.{DD_SITE}/api/v1/downtime"
HEADERS = {"Content-Type": "application/json", "DD-API-KEY": DD_API_KEY}

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

def get_instances_by_tag(tag_key, tag_value):
    """Get a list of EC2 instance IDs based on tag key-value pairs."""
    response = ec2_client.describe_instances(
        Filters=[{"Name": f"tag:{tag_key}", "Values": [tag_value]}]
    )
    instances = [
        instance["InstanceId"]
        for reservation in response["Reservations"]
        for instance in reservation["Instances"]
    ]
    logger.info(f"Instances with tag {tag_key}={tag_value}: {instances}")
    return instances

def create_datadog_downtime(instance_ids):
    """Create a Datadog downtime to mute monitoring."""
    try:
        payload = {
            "scope": [f"instance-id:{instance}" for instance in instance_ids],
            "message": "Muting during Datadog agent upgrade",
            "start": int(time.time()),
            "end": int(time.time()) + 1800,  # 30 minutes
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

def send_ssm_command(version, tag_value):
    """Send an SSM command to update Datadog agent on instances with a specific tag."""
    instances = get_instances_by_tag("dd_agent", tag_value)
    if not instances:
        logger.warning(f"No instances found with tag dd_agent={tag_value}. Skipping SSM command.")
        return None

    downtime_id = create_datadog_downtime(instances)

    # Correctly extract agentmajorversion and agentminorversion
    version_parts = version.split(".", 1)  # Split only on the first period
    agentmajorversion = version_parts[0]   # First part is the major version
    agentminorversion = version_parts[1] if len(version_parts) > 1 else "0"  # Rest is the minor version

    response = ssm_client.send_command(
        DocumentName=SSM_DOCUMENT_NAME,
        Targets=[{"Key": "tag:dd_agent", "Values": [tag_value]}],
        Parameters={
            "action": ["InstallOrUpgrade"],
            "apikey": [DD_API_KEY],
            "hostname": [DD_SITE],
            "agentmajorversion": [agentmajorversion],
            "agentminorversion": [agentminorversion],
        }
    )
    
    command_id = response["Command"]["CommandId"]
    logger.info(f"SSM Command for {tag_value} version {version} triggered. Command ID: {command_id}")

    # Remove Datadog downtime after upgrade
    if downtime_id:
        time.sleep(1800)  # Wait 30 minutes before unmuting
        remove_datadog_downtime(downtime_id)

    return command_id

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
    
    # Get the latest and penultimate versions and approval status
    latest_version, penultimate_version, approved_status = query_athena()

    # If the latest version is approved, execute SSM commands for both latest and penultimate versions
    if approved_status == "Yes":
        logger.info(f"Version {latest_version} is approved. Triggering SSM updates.")
        send_ssm_command(latest_version, "latest")

        if penultimate_version:
            logger.info(f"Triggering SSM update for penultimate version {penultimate_version}.")
            send_ssm_command(penultimate_version, "penultimate")
    else:
        logger.info(f"Version {latest_version} is NOT approved. Skipping SSM update.")

        # Check if it's the first day of the month and if file is older than 30 days
        if datetime.now().day == 1:
            if check_file_age():
                logger.info("CSV file is older than 30 days. Sending SNS notification.")
                send_sns_notification()
    
    return {"message": f"The approval status of version {latest_version} is {approved_status}"}
