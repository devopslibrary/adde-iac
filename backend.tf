# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Use S3 as Backend
terraform {
  backend "s3" {
    bucket         = "adde-terraform"
    key            = "infrastructure.tfstate"
    region         = "us-east-1"
    dynamodb_table = "adde-terraform-state-lock"
  }
}

# S3 Bucket for Storing TF State
resource "aws_s3_bucket" "tf_bucket" {
  bucket = "${var.name}-terraform"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "tf_bucket" {
  bucket                  = aws_s3_bucket.tf_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB for State Locking
resource "aws_dynamodb_table" "dynamodb_tf_state_lock" {
  name           = "${var.name}-terraform-state-lock"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}
