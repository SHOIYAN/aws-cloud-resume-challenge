terraform {
  required_providers {
    aws = {
      version =">=4.9.0"
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile ="terraform-user"
  region = "us-east-1"
}
terraform {
  required_providers {
    aws = {
      version =">=4.9.0"
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile ="terraform-user"
  region = "us-east-1"
}