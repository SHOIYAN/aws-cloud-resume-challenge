terraform {
  required_providers {
    aws = {

      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile ="elliot"
  region = "us-east-1"
}