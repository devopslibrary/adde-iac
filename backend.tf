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
