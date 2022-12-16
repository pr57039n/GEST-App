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
    engine = var.engine
    engine_version = var.engine_version
    instance_class = var.instance_class
    dbname = var.dbname
    username = var.username
    password = var.password
    bucket_name = var.bucket_name
}


