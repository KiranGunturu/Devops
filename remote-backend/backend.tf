terraform {
  backend "s3" {
    bucket = "terraform-demo-gk"
    region = "us-east-1"
    key = "tfstate/terraform.tfstate"
    dynamodb_table = "terraform_lock"
    
  }
}