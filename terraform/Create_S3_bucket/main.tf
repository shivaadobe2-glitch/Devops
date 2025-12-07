terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
}

resource "aws_s3_bucket" "my_static_website" {
  bucket = "my-unique-bucket-badugus"
}

resource "aws_s3_bucket_lifecycle_configuration" "my-lifecycle-config" {
  bucket = aws_s3_bucket.my_static_website.id

  rule {
    id = "expiration"
    status = "Enabled"

    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 365
    }
    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

resource "aws_s3_bucket_website_configuration" "My-website-config" {
  bucket  = aws_s3_bucket.my_static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  
}
