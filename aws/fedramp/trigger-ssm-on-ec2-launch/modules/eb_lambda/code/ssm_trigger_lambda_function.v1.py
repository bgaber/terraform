import json
import boto3
import os

ssm_client = boto3.client("ssm")
ec2_client = boto3.client("ec2")

SSM_DOCUMENT_NAME = os.environ["SSM_DOCUMENT_NAME"]  # SSM Document to run
TAG_KEY = "SSM_Run_Executed"  # Tag to ensure execution happens only once

def lambda_handler(event, context):
    print(f"Received event: {json.dumps(event)}")

    # Extract the instance ID
    instance_id = event["detail"]["instance-id"]

    # Check if the instance has already executed the SSM command
    response = ec2_client.describe_instances(InstanceIds=[instance_id])
    tags = {tag["Key"]: tag["Value"] for tag in response["Reservations"][0]["Instances"][0].get("Tags", [])}
    
    if TAG_KEY in tags and tags[TAG_KEY] == "true":
        print(f"Skipping instance {instance_id}, SSM Run Command has already been executed.")
        return {"message": f"Instance {instance_id} already executed SSM command."}

    # Run the SSM command
    response = ssm_client.send_command(
        DocumentName=SSM_DOCUMENT_NAME,
        Targets=[{"Key": "InstanceIds", "Values": [instance_id]}],
        Parameters={
            "action": ["InstallOrUpgrade"]
        }
    )

    print(f"SSM Command Triggered: {response}")

    # Tag instance to mark that the SSM command has been executed
    ec2_client.create_tags(
        Resources=[instance_id],
        Tags=[{"Key": TAG_KEY, "Value": "true"}]
    )

    return {"message": f"SSM Run Command executed for instance {instance_id}"}
