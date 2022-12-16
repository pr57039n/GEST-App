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
    aws_security_group_load_balancer_id = module.EC2.aws_security_group_load_balancer_id
    private_instance1_id = module.EC2.private_instance1_id
    private_instance2_id = module.EC2.private_instance2_id
}


# import EC2 module
module "EC2" {
    source = "./modules/EC2"
    key_name = var.key_name
}


