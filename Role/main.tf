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

# Get the policy by name
data "aws_iam_policy" "required-policy" {
  name = "AmazonS3FullAccess"
}

# Create the role
resource "aws_iam_role" "system-role" {
  name = "s3accessec2"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}


# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach-s3" {
  role       = aws_iam_role.system-role.name
  policy_arn = data.aws_iam_policy.required-policy.arn
}

# Attach role to an instance profile

resource "aws_iam_instance_profile" "ec2" {
    name       = "ec2"
    role       = aws_iam_role.system-role.name
}