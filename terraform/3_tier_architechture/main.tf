terraform {
  required_providers {
    aws ={
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
}
provider "aws" {region = var.region}

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

resource "aws_instance" "application-instance" {
    ami = data.aws_ami.latest-amazon-linux.id 
    instance_type = "t3.micro"
    associate_public_ip_address = false
}