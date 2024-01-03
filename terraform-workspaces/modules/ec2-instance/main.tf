provider "aws" {
    region = "us-east-1"
}
variable "ami" {
    description = "This is ami for the ec2 instance"
}

variable "instance_type" {
    description = "this is the instance type. ex: t2.micro"
}
resource "aws_instance" "example" {
    ami = var.ami
    instance_type = var.instance_type
}