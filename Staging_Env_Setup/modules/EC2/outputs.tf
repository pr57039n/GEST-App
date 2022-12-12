output "private_ec2_1_ip" {
    value = aws_instance.private_ec2_1.private_ip
}

output "private_ec2_2_ip" {
    value = aws_instance.private_ec2_2.private_ip
}

output "aws_security_group_load_balancer_id" {
    value = aws_security_group.load-balancer.id
}

output "aws_security_group_ec2" {
    value = aws_security_group.ec2_access.id
}
