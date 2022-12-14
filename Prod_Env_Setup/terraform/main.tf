#variable "aws_access_key" {}
#variable "aws_secret_key" {}

provider "aws" {
  access_key = "AKIA2ODOMADP55Y2L2NS"
  secret_key = "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"
  region = "us-east-1"
}

/*terraform {
  backend "s3" {
    bucket         = "k6application"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_state"
  }
}*/

module "vpc" {
  source       = "./Modules/vpc"
 #region       = "us-east-1"
  #project_name = "Django-Deployment"
}

/*module "Instance" {
  source = "./Modules/Instances"
}*/
