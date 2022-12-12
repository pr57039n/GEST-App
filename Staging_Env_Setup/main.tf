# Variables

variable "aws_access_key" {}
variable "aws_secret_key" {}


# Provider
provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = var.region
}

# import VPC module
module "VPC" {
    source = "./modules/VPC"
    region = var.region
    project_name = var.project_name
    cidr_block = var.cidr_block
    public_subnet_az1_cidr = var.public_subnet_az1_cidr
    private_subnet_az1_cidr = var.private_subnet_az1_cidr
    public_subnet_az2_cidr = var.public_subnet_az2_cidr
    private_subnet_az2_cidr = var.private_subnet_az2_cidr
    aws_security_group_load_balancer_id = module.EC2.aws_security_group_load_balancer_id
}


# import EC2 module
module "EC2" {
    source = "./modules/EC2"
    vpc_id = module.VPC.vpc_id
    key_name = var.key_name
    private_subnet_az1_id = module.VPC.private_subnet_az1
    private_subnet_az2_id = module.VPC.private_subnet_az2
}


