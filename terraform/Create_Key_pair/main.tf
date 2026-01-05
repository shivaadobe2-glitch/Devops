terraform {
  required_providers {
    aws =  {
    source = "hashicorp/aws"
    version = "~> 6.0"
  }
  }
}

provider "aws" {
  region = var.region # Your region
}

# Generate RSA key pair (4096-bit for security)
resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096  # Strong key size [web:49]
}

# Save private key locally (secure permissions)
resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.rsa_key.private_key_pem
  file_permission = "0600"
  filename        = "./my-private-key.pem"
}

# Save public key locally (optional)
resource "local_file" "public_key" {
  content  = tls_private_key.rsa_key.public_key_openssh
  filename = "./my-public-key.pub"
}

# Upload public key to AWS
resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = tls_private_key.rsa_key.public_key_openssh
  
  lifecycle {
    prevent_destroy = false
  }
  
  tags = {
    Name = "My Key"
  }
}

output "private_key_path" {
  value       = local_sensitive_file.private_key.filename
  description = "SSH with: chmod 400 react-rsa-key.pem && ssh -i react-rsa-key.pem ec2-user@<public-IP>"
}

output "aws_key_name" {
  value = aws_key_pair.my_key.key_name
}
