provider "aws" {
    region = "us-east-1"
}

provider "azurerm" {
    subscription_id = "your-azure-subscription-id"
    client_id = "your-azure-client-id"
    client_secret = "your-azure-client-secret"
    tenant_id = "your-azure-tenant-id"
}

resource "aws_instance" "ec2" {
    ami = "ami-0fc5d935ebf8bc3bc"
    instance_type = "t2.micro"
}

resource "azure_virtual_machine" "example" {
    name = "example-vm"
    location = "eastus"
    size = "Standard_A1"
}