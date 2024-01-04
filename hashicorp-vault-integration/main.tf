provider "aws" {
    region = "us-east-1"
}

provider "vault" {
    address = "http://ec2-ip-address:8200"
    skip_child_token = true

    auth_login {
      path = "auth/approle/login"
      parameters = {
        role_id = "<>"
        secret_id = "<>"

    }
    }
}

/* https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/kv_secret_v2 */

data "vault_kv_secret_v2" "example" {
    mount = "kv"
    name = "test-secret"
  
}

# crete an ec2 instance and assign the tag name as one we have as secret that is stored in the vault
resource "aws_instance" "example" {
    ami = "ami-0fc5d935ebf8bc3bc"
    instance_type = "t2.micro"
    tags = {
      secret = data.vault_kv_secret_v2.example.data["username"]
    }
  
}
 # crete an s3 bucket and assign the name of the bucket as one we have as secret that is stored in the vault
 
resource "aws_s3_bucket" "name" {
    bucket = data.vault_kv_secret_v2.example.data["username"]
  
}