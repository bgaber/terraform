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
LINUX_SSM_DOCUMENT_NAME   = os.environ["LINUX_SSM_DOCUMENT_NAME"]  # Linux SSM Document
WINDOWS_SSM_DOCUMENT_NAME = os.environ["WINDOWS_SSM_DOCUMENT_NAME"]  # Windows SSM Document

# Initialize AWS clients
ssm_client = boto3.client("ssm", region_name=AWS_REGION)
ec2_client = boto3.client("ec2", region_name=AWS_REGION)

def lambda_handler(event, context):
    print(f"Received event: {json.dumps(event)}")

    # Extract instance ID
    instance_id = event["detail"]["responseElements"]["instancesSet"]["items"][0]["instanceId"]

    # Get instance details to determine platform
    try:
        response = ec2_client.describe_instances(InstanceIds=[instance_id])
        instance = response["Reservations"][0]["Instances"][0]
        platform = instance.get("Platform", "Linux").lower()  # Defaults to Linux if "Platform" is missing
    except Exception as e:
        logger.error(f"Error retrieving instance details: {str(e)}")
        return {"message": "Error retrieving instance details"}

    # Select the correct SSM Document based on platform
    if platform == "windows":
        ssm_document_name = WINDOWS_SSM_DOCUMENT_NAME
    else:
        ssm_document_name = LINUX_SSM_DOCUMENT_NAME  # Default to Linux

    # Run the SSM command
    try:
        response = ssm_client.send_command(
            DocumentName=ssm_document_name,
            Targets=[{"Key": "InstanceIds", "Values": [instance_id]}],
            Parameters={
                "falconClientId": [FALCON_CLIENT_ID],
                "falconClientSecret": [FALCON_CLIENT_SECRET]
            }
        )

        command_id = response["Command"]["CommandId"]
        logger.info(f"Triggered SSM command {command_id} on {instance_id}")

        return {"message": f"SSM Run Command executed for {platform} instance {instance_id}"}

    except Exception as e:
        logger.error(f"Error triggering SSM Command: {str(e)}")
        return {"message": "Error triggering SSM Command"}
