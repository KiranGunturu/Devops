provider "aws" {
    alias = "us-east-1"
    region = "us-east-1"
}

provider "aws" {
    alias = "us-west-2"
    region = "us-west-2"
}

resource "aws_instance" "ec2" {
    ami = "ami-0fc5d935ebf8bc3bc"
    instance_type = "t2.micro"
    provider = "aws.us-east-1"
}

resource "aws_instance" "ec2" {
    ami = "ami-0fc5d935ebf8bc3bc"
    instance_type = "t2.micro"
    provider = "aws.us-west-2"
}
