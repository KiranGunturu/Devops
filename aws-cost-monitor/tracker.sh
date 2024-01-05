#!/bin/bash
# author: Gunturu
# Date: 1/5/2024
# version: 1.0
### AWS resource tracker ####

# s3 buckets
echo 'Print list of s3 buckets'
aws s3 ls > awsResourceTracker

# ec2 instances
echo 'Print list of EC2 Instances'
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId' >> awsResourceTracker

# lambda functions
echo 'Print list of lambda functions'
aws lambda list-functions | jq '.Functions[].FunctionName' >> awsResourceTracker

# IAM roles
echo 'Print list of IAM user ARNs'
aws iam list-users | jq '.Users[].Arn' >> awsResourceTracker


