terraform {
  required_providers {
    aws = {
      version =">=4.9.0"
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  shared_credentials_files  = ["C:/Users/USERS/.aws/credentials"]
  profile ="elliot"
  region = "us-east-1"
}