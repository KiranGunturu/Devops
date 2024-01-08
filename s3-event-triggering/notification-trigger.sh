# get aws account ID

aws_account_id=$(aws sts get-caller-identity --query 'Account' --output text)
echo "aws_account_id is: $aws_account_id"

