terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


terraform {
  backend "s3" {
    bucket = "nag-s3-bucket-123"
    key    = "terraform/CICD"
    region = "ap-south-1"
  }
}

resource "aws_instance" "web" {
  ami             = "ami-0fc5d935ebf8bc3bc"
  instance_type   = "t2.micro"
  key_name        = "valaxy"
  security_groups = ["demo_sg"]
}

resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "SSH Access"


  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-port"
  }
}


