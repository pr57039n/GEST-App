# Application Load Balancer 

resource "aws_lb" "docker_instance_LB" {
  name               = "docker-instances-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups = [var.aws_security_group_load_balancer_id]
  subnets            = [aws_subnet.public_subnet_az1.id, aws_subnet.public_subnet_az2.id]

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_lb_target_group" "docker_instances" {
  name        = "docker-instances-tg"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.VPC.id

  health_check {
    enabled = true
    path    = "/health"
    port = "traffic-port"
    healthy_threshold = 5
    timeout = 2
  }
  depends_on = [aws_lb.docker_instance_LB]
}

# Listener (redirects traffic from the load balancer to the target group)
resource "aws_alb_listener" "ec2-alb-http-listener" {
  load_balancer_arn = aws_lb.docker_instance_LB.arn
  port              = "80"
  protocol          = "HTTP"
  #depends_on        = [aws_alb_target_group.docker_instances]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.docker_instances.arn
  }
}

# Target Groups for instances
resource "aws_lb_target_group_attachment" "attach-app1" {
  target_group_arn = aws_lb_target_group.docker_instances.arn
  target_id = var.private_instance1_id
  port = "80"
}

resource "aws_lb_target_group_attachment" "attach-app2" {
  target_group_arn = aws_lb_target_group.docker_instances.arn
  target_id = var.private_instance2_id
  port = "80"
}
