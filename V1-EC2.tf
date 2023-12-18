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
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  key_name      = "valaxy"
}

resource "aws_vpc" "dpw-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "dpw-vpc"
  }
}


