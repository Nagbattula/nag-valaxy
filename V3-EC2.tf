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
  #security_groups = ["demo_sg"]
  vpc_security_group_ids = [aws_security_group.demo_sg.id]
  subnet_id              = aws_subnet.dpw-public_subent_01.id
  for_each               = toset(["Jenkins-master", "Build-slave", "Ansible"])
  tags = {
    Name = "${each.key}"
  }
}

resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "SSH Access"
  vpc_id      = aws_vpc.dpw-vpc.id


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

resource "aws_vpc" "dpw-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "dpw-vpc"
  }
}
resource "aws_subnet" "dpw-public_subent_01" {
  vpc_id                  = aws_vpc.dpw-vpc.id
  cidr_block              = "10.1.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "dpw-public_subent_01"
  }
}

resource "aws_subnet" "dpw-public_subent_02" {
  vpc_id                  = aws_vpc.dpw-vpc.id
  cidr_block              = "10.1.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east- 1b"
  tags = {
    Name = "dpw-public_subent_02"
  }
}

resource "aws_internet_gateway" "dpw-igw" {
  vpc_id = aws_vpc.dpw-vpc.id
  tags = {
    Name = "dpw-igw"
  }
}

resource "aws_route_table" "dpw-public-rt" {
  vpc_id = aws_vpc.dpw-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dpw-igw.id
  }
  tags = {
    Name = "dpw-public-rt"
  }
}

resource "aws_route_table_association" "dpw-rta-public-subent-01" {
  subnet_id      = aws_subnet.dpw-public_subent_01.id
  route_table_id = aws_route_table.dpw-public-rt.id
}

resource "aws_route_table_association" "dpw-rta-public-subent-02" {
  subnet_id      = aws_subnet.dpw-public_subent_02.id
  route_table_id = aws_route_table.dpw-public-rt.id
}




