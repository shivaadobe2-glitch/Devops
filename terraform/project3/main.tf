terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
}

resource "aws_s3_bucket" "My-static-website" {
  bucket = "My-unique-bucket-badugu's"
}

resource "aws_s3_bucket_website_configuration" "My-website-config" {
  bucket  = aws_s3_bucket.My-static-website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  
}