terraform {
  required_providers {
    aws = {
      version =">=4.9.0"
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  shared_credentials_files  = ["C:/Users/USERS/.aws/credentials"]
  profile ="elliot"
  
}