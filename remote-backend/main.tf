provider "aws" {
    region = "us-east-1"
  
}

resource "aws_instance" "ec2" {
  instance_type = "t2.micro"
  ami = "ami-0fc5d935ebf8bc3bc"
  subnet_id = "subnet-052209816b9c28f0a"
}

resource "aws_s3_bucket" "s3_instance" {
    bucket = "terraform-demo-gk"
  
}

resource "aws_dynamodb_table" "terraform_lock" {
  name = "terraform_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  
}