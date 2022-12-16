output "alb_url" {
    value = "${aws_lb.docker_instance_LB.dns_name}"
}