terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
}

provider "aws" {region = var.region}

# data "aws_ami" "latest_ami"{
#     most_recent = true
#     owners = ["amazon"]
#     filter {
#       name = "name"
#       values = [ "Amazon Linux 2023 AMI 2023.9.20251208.0 x86_64 HVM kernel-6.1*" ]
#       #values = ["Windows_Server-2025-English-Full-Base-2025.11.12*"]
#     }
#     filter {
#       name = "virtualization-type"
#       values = ["hvm"]
#     } 
# }

data "aws_vpc" "selected"{default = true}

# data "aws_subnets" "selected_subnet" {
#     filter {
#       name = "vpc-id"
#       values = [data.aws_vpc.selected.id]
#     }
# }

resource "aws_instance" "My-first-machine" {
    ami = "ami-0018df03456b303db"
    instance_type = "t3.micro"
    key_name = "my-key"
    user_data = <<EOF
      #!/bin/bash
      sudo yum update -y
      sudo amazon-linux-extras install nginx1 -y
      sudo systemctl enable nginx
      sudo systemctl start nginx
    EOF
    #subnet_id = data.aws_subnets.selected_subnet.ids[0]
    tags = {
      Name = "Terraform-ins001"
    }
    associate_public_ip_address = false
  
}

output "my-final-output" {value = aws_instance.My-first-machine.id}