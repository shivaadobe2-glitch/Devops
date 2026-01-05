terraform {
  required_providers {
    aws ={
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
}
provider "aws" {region = var.region}
#default vpc
resource "aws_default_vpc" "default" {

}
#default internet gateway
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = ["${aws_default_vpc.default.id}"]
  }
}

#create 3 public subnets
resource "aws_subnet" "public" {
  count                   = 3
  vpc_id                  = aws_default_vpc.default.id
  cidr_block              = var.cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

#create route table for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_default_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }
}

#associate public subnets with route table
resource "aws_route_table_association"public_subnet_association {
  count          = 3
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

data "aws_ami" "latest-amazon-linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
# Create security group for application tier
resource "aws_security_group" "application_sg" {
  name        = "application-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "ssh"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create 3 EC2 instances in public subnets
resource "aws_instance" "application-instance" {
    count = 3
    ami = data.aws_ami.latest-amazon-linux.id 
    instance_type = "t3.micro"
    key_name = "my-key"
    user_data = <<EOF
      #!/bin/bash
      sudo yum update -y
      sudo amazon-linux-extras install nginx1 -y
      sudo systemctl enable nginx
      sudo systemctl start nginx
    EOF
    tags = {
      Name = "App-Server-${count.index + 1}"
    }
    subnet_id = aws_subnet.public[count.index].id
}