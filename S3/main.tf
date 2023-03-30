terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"  
  shared_config_files      = ["/Users/rahulreddy/.aws/config"]
  shared_credentials_files = ["/Users/rahulreddy/.aws/credentials"]
  profile                  = "project"
}

#S3 Resource

resource "aws_s3_bucket" "aws_s3-bucket_project" {
  bucket = "rahul-bucket-prod-log"
  versioning {
    enabled = true
  }

  tags = {
    Name        = "Project-1"
    Environment = "Storing Logs"
  }
}