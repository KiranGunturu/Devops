# terraform
docs - https://registry.terraform.io/providers/hashicorp/aws/latest/docs 
aws configure 
aws --version 
terraform --version cd to path where we have .tf files terraform init - initialize few things like provider, authenticate to provider(aws) 
terraform plan - dry to run to check what happens when we run terraform apply command like with what options instance is going to create 
terraform apply - to create the resources on the cloud provider like ec2 
terraform destroy - to destory or terminate what we created as part of apply command 
AMI ID - to locate this - go to ec2 - launch instance and select anyone like macOS, ubuntu, amazon linux and that will show us an AMI 
terraform.tfstate - Terraform maintains all the metadata like what we all created in this file.
