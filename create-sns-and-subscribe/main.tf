# define the aws provider configuration
provider "aws" {
    region = "us-east-1"
  
}

resource "aws_sns_topic" "glue_schema_change" {
  name            = "glue_schema_change"
  display_name = "glue_schema_change"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
tags = {
    Name = "customers_sns"
  }
}

resource "aws_sns_topic_subscription" "target" {
  for_each  = toset(["kiran.gntdm@gmail.com", "kiranusa15@gmail.com"])
  topic_arn = aws_sns_topic.glue_schema_change.arn
  protocol  = "email"
  endpoint  = each.value
}


