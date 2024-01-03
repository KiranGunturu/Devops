# define the aws provider configuration
provider "aws" {
    region = "us-east-1"
  
}

variable "cidr" {
    default = "10.0.0.0/16"
  
}

resource "aws_key_pair" "example" {
    key_name = "gunturu"
    public_key = file("~/.ssh/id_rsa.pub")
  
}

resource "aws_vpc" "myvpc" {
    cidr_block = var.cidr
  
}

resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.myvpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  
}

resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.RT.id
  
}

resource "aws_security_group" "webSg" {
    name = "web"
    vpc_id = aws_vpc.myvpc.id
    ingress {
        description = "HTTP from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "web-sg"

    }
    }

resource "aws_instance" "server" {
    ami = "ami-0fc5d935ebf8bc3bc"
    instance_type = "t2.micro"
    key_name = aws_key_pair.example.key_name
    vpc_security_group_ids = [aws_security_group.webSg.id]
    subnet_id = aws_subnet.sub1.id
    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = file("~/.ssh/id_rsa")
        host = self.public_ip
      
    }

    # File provisioner to copy a file from local to the remote ec2 instance

    provisioner "file" {
        source = "app.py"
        destination = "/home/ubuntu/app.py" 
    }

    provisioner "remote-exec" {
        inline = [ 
            "echo 'Hello from the remote instance'",
            "sudo apt update -y", # update package lists
            "sudo apt-get install -y python3-pip", # example package installation
            "cd /home/ubuntu",
            "sudo pip3 install flask",
            "sudo python3 app.py",

         ]
      
    }
  
}


