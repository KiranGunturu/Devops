variable "ami_value" {
    description = "value for the AMI"
}

variable "instance_type_value" {
    description = "value for the instance_type"
  
}

variable "subnet_id_value" {
    description = "value of the subnet_id"
  
}
provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "ec2" {
    ami = var.ami_value
    instance_type = var.instance_type_value
    subnet_id = var.subnet_id_value
  
}