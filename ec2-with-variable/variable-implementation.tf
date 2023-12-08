# define an input variable for the EC2 instance type

 variable "instance_type" {
    description = "EC2 instance type"
    type = string
    default = "t2.micro"
   
 }

 # define an input variable for the EC2 AMI id

 variable "ami_id" {
   description = "EC2 AMI ID"
   type = string
 }

 # configure AWS provider

 provider "aws" {
    region = "us-east-1"
   
 }

 # create an EC2 instance using the input variable

 resource "aws_instance" "ec2" {
    ami = var.ami_id
    instance_type = var.instance_type
   
 }

 # define an output variable to expose the public IP Address of the EC2 instance
output "public_ip" {
    description = "public IP dddress of the EC2 Instance"
    value = aws_instance.ec2.public_ip
}
