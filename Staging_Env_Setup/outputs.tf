output "region" {
    value = var.region
}

output "project_name" {
    value = var.project_name
}

output "private_ec2_1_ip" {
    value = module.EC2.private_ec2_1.private_ip
}

output "private_ec2_2_ip" {
    value = module.EC2.private_ec2_2.private_ip
}
