import json
import boto3
import os
import logging

# Configure logging for CloudWatch
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Fetch environment variables
AWS_REGION           = os.environ["AWS_REGION"]
FALCON_CLIENT_ID     = os.environ["FALCON_CLIENT_ID"]
FALCON_CLIENT_SECRET = os.environ["FALCON_CLIENT_SECRET"]
LINUX_SSM_DOCUMENT_NAME   = os.environ["LINUX_SSM_DOCUMENT_NAME"]       # Linux SSM Document to run
WINDOWS_SSM_DOCUMENT_NAME = os.environ.get("WINDOWS_SSM_DOCUMENT_NAME") # Windows SSM Document to run
TAG_KEY = "SSM_Run_Executed"                                            # Tag to ensure execution happens only once

# Initialize AWS clients
ssm_client = boto3.client("ssm", region_name=AWS_REGION)
ec2_client = boto3.client("ec2", region_name=AWS_REGION)

def lambda_handler(event, context):
    print(f"Received event: {json.dumps(event)}")

    # Extract the instance ID
    instance_id = event["detail"]["instance-id"]

    # Check if the instance has already executed the SSM command
    # response = ec2_client.describe_instances(InstanceIds=[instance_id])
    # tags = {tag["Key"]: tag["Value"] for tag in response["Reservations"][0]["Instances"][0].get("Tags", [])}
    
    # if TAG_KEY in tags and tags[TAG_KEY] == "true":
    #     print(f"Skipping instance {instance_id}, SSM Run Command has already been executed.")
    #     return {"message": f"Instance {instance_id} already executed SSM command."}

    # Run the SSM command
    response = ssm_client.send_command(
        DocumentName=LINUX_SSM_DOCUMENT_NAME,
        Targets=[{"Key": "InstanceIds", "Values": [instance_id]}],
        Parameters={
            "falconClientId": [FALCON_CLIENT_ID],
            "falconClientSecret": [FALCON_CLIENT_SECRET]
        }
    )

    logger.info(f"SSM Command Triggered: {response}")

    command_id = response["Command"]["CommandId"]
    logger.info(f"SSM Command triggered. Command ID: {command_id}")

    # Tag instance to mark that the SSM command has been executed
    ec2_client.create_tags(
        Resources=[instance_id],
        Tags=[{"Key": TAG_KEY, "Value": "true"}]
    )

    return {"message": f"SSM Run Command executed for instance {instance_id}"}
