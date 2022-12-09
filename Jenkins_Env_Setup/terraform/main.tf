terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.0"
    }
  }
}
#PROVIDER
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = "us-east-1"
  
}

#VPC
resource "aws_vpc" "Kura6_VPC" {
  cidr_block = "172.20.0.0/16"
  tags = {
    Name = "Kura6_VPC"
  }
}



