import json
import boto3
import os
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Fetch environment variables
AWS_REGION           = os.environ["AWS_REGION"]
FALCON_CLIENT_ID     = os.environ["FALCON_CLIENT_ID"]
FALCON_CLIENT_SECRET = os.environ["FALCON_CLIENT_SECRET"]
LINUX_SSM_DOCUMENT_NAME   = os.environ["LINUX_SSM_DOCUMENT_NAME"]
WINDOWS_SSM_DOCUMENT_NAME = os.environ.get("WINDOWS_SSM_DOCUMENT_NAME")

# Initialize AWS clients
ssm_client = boto3.client("ssm", region_name=AWS_REGION)
ec2_client = boto3.client("ec2", region_name=AWS_REGION)

def get_instance_platform(instance_id):
    """Determine the OS platform of the EC2 instance"""
    response = ec2_client.describe_instances(InstanceIds=[instance_id])
    instance = response['Reservations'][0]['Instances'][0]
    
    # Check for Windows platform first
    if instance.get('Platform', '').lower() == 'windows':
        return 'Windows'
    # Check platform details for Linux
    if 'PlatformDetails' in instance and 'linux' in instance['PlatformDetails'].lower():
        return 'Linux'
    return 'Unknown'

def lambda_handler(event, context):
    logger.info(f"Received event: {json.dumps(event)}")
    
    # Extract instance ID from CloudTrail event
    instance_id = event['detail']['responseElements']['instancesSet']['items'][0]['instanceId']
    
    # Determine instance platform
    platform = get_instance_platform(instance_id)
    logger.info(f"Detected platform: {platform} for instance {instance_id}")

    # Select appropriate SSM document
    if platform == 'Linux':
        document_name = LINUX_SSM_DOCUMENT_NAME
    elif platform == 'Windows' and WINDOWS_SSM_DOCUMENT_NAME:
        document_name = WINDOWS_SSM_DOCUMENT_NAME
    else:
        logger.error(f"Unsupported platform {platform} or missing Windows SSM document")
        return {"status": "error", "message": "Unsupported platform or missing document"}

    # Run SSM command with platform-specific parameters
    try:
        response = ssm_client.send_command(
            InstanceIds=[instance_id],
            DocumentName=document_name,
            Parameters={
                'falconClientId': [FALCON_CLIENT_ID],
                'falconClientSecret': [FALCON_CLIENT_SECRET]
            },
            TimeoutSeconds=3600
        )
        
        command_id = response['Command']['CommandId']
        logger.info(f"Triggered SSM command {command_id} on {instance_id}")
        
        return {
            "status": "success",
            "instance_id": instance_id,
            "platform": platform,
            "command_id": command_id
        }
    
    except Exception as e:
        logger.error(f"Error executing SSM command: {str(e)}")
        return {"status": "error", "message": str(e)}
