import json
import boto3
import os
import time
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

# Configuration
MAX_SSM_WAIT_ATTEMPTS = 20  # ~5 minutes (15s intervals)
SSM_WAIT_INTERVAL = 15
COMMAND_RETRIES = 3
RETRY_DELAY = 10

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

def wait_for_ssm_registration(instance_id):
    """Wait until instance appears in SSM inventory"""
    for attempt in range(MAX_SSM_WAIT_ATTEMPTS):
        try:
            response = ssm_client.describe_instance_information(
                Filters=[{'Key': 'InstanceIds', 'Values': [instance_id]}]
            )
            if response['InstanceInformationList']:
                logger.info(f"Instance {instance_id} registered with SSM")
                return True
        except Exception as e:
            logger.warning(f"SSM check attempt {attempt+1} failed: {str(e)}")
        
        time.sleep(SSM_WAIT_INTERVAL)
    
    logger.error("SSM registration timeout exceeded")
    return False

def lambda_handler(event, context):
    logger.info(f"Received event: {json.dumps(event)}")
    
    try:
        # Extract instance ID from CloudTrail event
        instance_id = event['detail']['responseElements']['instancesSet']['items'][0]['instanceId']
        logger.info(f"Processing new instance: {instance_id}")

        # Wait for EC2 to reach running state
        logger.info("Waiting for instance to reach running state...")
        ec2_client.get_waiter('instance_running').wait(InstanceIds=[instance_id])
        
        # Wait for system status checks
        logger.info("Waiting for system status checks...")
        ec2_client.get_waiter('system_status_ok').wait(InstanceIds=[instance_id])

        # Wait for SSM registration
        logger.info("Checking SSM registration...")
        if not wait_for_ssm_registration(instance_id):
            raise Exception("Instance failed to register with SSM")

        # Determine platform after instance is ready
        platform = get_instance_platform(instance_id)
        logger.info(f"Detected platform: {platform} for instance {instance_id}")

        # Select appropriate SSM document
        if platform == 'Linux':
            document_name = LINUX_SSM_DOCUMENT_NAME
        elif platform == 'Windows' and WINDOWS_SSM_DOCUMENT_NAME:
            document_name = WINDOWS_SSM_DOCUMENT_NAME
            time.sleep(30)
        else:
            logger.error(f"Unsupported platform {platform} or missing Windows SSM document")
            raise Exception(f"Unsupported platform {platform} or missing Windows SSM document")

        # Execute SSM command with retries
        for attempt in range(COMMAND_RETRIES):
            try:
                response = ssm_client.send_command(
                    InstanceIds=[instance_id],
                    DocumentName=document_name,
                    Parameters={
                        "falconClientId": [FALCON_CLIENT_ID],
                        "falconClientSecret": [FALCON_CLIENT_SECRET]
                    },
                    TimeoutSeconds=1200
                )
                command_id = response['Command']['CommandId']
                logger.info(f"Started SSM command {command_id} on {instance_id}")
                return {
                    'statusCode': 200,
                    'body': f"Command {command_id} executed on {platform} instance {instance_id}"
                }
            except ssm_client.exceptions.InvalidInstanceId as e:
                logger.warning(f"SSM not ready, retry {attempt+1}/{COMMAND_RETRIES}")
                time.sleep(RETRY_DELAY)
            except Exception as e:
                raise  # Re-raise other exceptions

        raise Exception("Failed to send SSM command after retries")

    except Exception as e:
        logger.error(f"Error processing instance {instance_id}: {str(e)}")
        return {
            'statusCode': 500,
            'body': f"Error processing instance {instance_id}: {str(e)}"
        }
