resource "aws_ecs_cluster" "test" {
  name = "${var.ecs_cluster_name}-cluster"
}

resource "aws_cloudwatch_log_group" "log-group" {
  name = "/ecs/django-logs"

  tags = {
    Application = "django-app"
  }
}

resource "aws_ecs_task_definition" "aws-django-task" {
  family = "django-task"

  container_definitions = <<EOF
  [
  {
      "name": "GEST-App",
      "image": "[image location]",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/django-logs",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "containerPort": 8000
        }
      ]
    }
  ]
  EOF

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = [replace arn]
  task_role_arn            = [replace arn]
}

# ECS Service
resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "url-ecs-service"
  cluster              = aws_ecs_cluster.aws-ecs-cluster.id
  task_definition      = aws_ecs_task_definition.aws-ecs-task.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id
    ]
    assign_public_ip = false
    security_groups  = module.vpc.aws_security_group.ecs.id
  }
}
