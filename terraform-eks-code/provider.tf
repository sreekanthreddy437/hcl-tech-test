# Define the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Backend Configuration (for S3)
terraform {
  backend "s3" {
    bucket = "sreekanth-bucket-hcl-test"  
    key    = "terraform.tfstate"          
    region = "us-east-1"              
  }
}

