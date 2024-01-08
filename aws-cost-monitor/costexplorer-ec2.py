import boto3
from datetime import datetime, timedelta

def get_ec2_instance_costs():
    # Set your AWS credentials
    aws_access_key_id = 'AKIAQVAK4EQUMXU7W5AH'
    aws_secret_access_key = 'zz9Z8p1+ko0nQLCVCDNuV2v7AkJl9oSMOdKS9mxG'
    aws_region = 'us-east-1'

    # Create a session using your credentials
    session = boto3.Session(
        aws_access_key_id=aws_access_key_id,
        aws_secret_access_key=aws_secret_access_key,
        region_name=aws_region
    )

    # Create a Cost Explorer client
    ce_client = session.client('ce')

    # Get the current date and 7 days ago
    end_date = datetime.utcnow()
    start_date = end_date - timedelta(days=7)

    # Format dates to string
    start_date_str = start_date.strftime('%Y-%m-%d')
    end_date_str = end_date.strftime('%Y-%m-%d')

    # Get the cost and usage data for each EC2 instance
    response_per_instance = ce_client.get_cost_and_usage(
        TimePeriod={
            'Start': start_date_str,
            'End': end_date_str
        },
        Granularity='DAILY',
        Metrics=['UnblendedCost'],
        Filter={
            'Dimensions': {
                'Key': 'SERVICE',
                'Values': ['Amazon EC2']
            }
        },
        GroupBy=[
            {'Type': 'DIMENSION', 'Key': 'LINKED_ACCOUNT'},
            {'Type': 'DIMENSION', 'Key': 'RESOURCE_ID'}
        ]
    )

    # Display per-instance cost
    for result in response_per_instance['ResultsByTime']:
        linked_account = result['Groups'][0]['Keys'][0]
        ec2_instance_id = result['Groups'][1]['Keys'][0]
        total_cost_instance = float(result['Total']['UnblendedCost']['Amount'])
        print(f"Linked Account: {linked_account}, EC2 Instance ID: {ec2_instance_id}, Total Cost: ${total_cost_instance}")

if __name__ == "__main__":
    get_ec2_instance_costs()
