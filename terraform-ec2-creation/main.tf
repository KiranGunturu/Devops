provider "aws" {
  region = "us-east-1" //set your region
}

resource "aws_instance" "ec2" {
    ami = "ami-0fc5d935ebf8bc3bc"
    instance_type = "t2.micro"
    subnet_id = "subnet-052209816b9c28f0a"
    key_name = "aws_login"
  
}