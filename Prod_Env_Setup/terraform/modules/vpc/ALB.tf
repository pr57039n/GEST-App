# Test load balancer

resource "aws_lb" "test-LB" {
  name               = "${var.ecs_cluster_name}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.load-balancer.id]
  subnets            = ["subnet-0e4735713790af595", "subnet-06db5e975a01e1b3e"]
}

resource "aws_lb_target_group" "django-app" {
  name        = "${var.ecs_cluster_name}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "vpc-0ae47649f0dfc8b6a"

  health_check {
    enabled = true
    path    = "/health"
    port = "traffic-port"
    healthy_threshold = 5
    timeout = 2
  }
  depends_on = [aws_lb.test-LB]
}

# Listener (redirects traffic from the load balancer to the target group)
resource "aws_alb_listener" "ecs-alb-http-listener" {
  load_balancer_arn = aws_lb.test-LB.arn
  port              = "80"
  protocol          = "HTTP"
  #depends_on        = [aws_alb_target_group.django-app]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.django-app.id
  }
}
