#VPC Main - Will become Prod
# resource "aws_vpc" "test-vpc" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_support   = true
#   enable_dns_hostnames = true
# }

# #Public Subnets
# resource "aws_subnet" "public-subnet-1" {
#   cidr_block        = var.public_subnet_1_cidr
#   map_public_ip_on_launch = "true"
#   vpc_id            = aws_vpc.test-vpc.id
#   availability_zone = var.availability_zones[0]
# }
# resource "aws_subnet" "public-subnet-2" {
#   cidr_block        = var.public_subnet_2_cidr
#   map_public_ip_on_launch = "true"
#   vpc_id            = aws_vpc.test-vpc.id
#   availability_zone = var.availability_zones[1]
# }

# #Private subnets
# resource "aws_subnet" "private-subnet-1" {
#   cidr_block        = var.private_subnet_1_cidr
#   vpc_id            = aws_vpc.test-vpc.id
#   availability_zone = var.availability_zones[0]
# }
# resource "aws_subnet" "private-subnet-2" {
#   cidr_block        = var.private_subnet_2_cidr
#   vpc_id            = aws_vpc.test-vpc.id
#   availability_zone = var.availability_zones[1]
# }

#Route tables for the subnets
 resource "aws_route_table" "public-route-table" {
   vpc_id = "vpc-0ae47649f0dfc8b6a"
 }
 resource "aws_route_table" "private-route-table" {
   vpc_id = "vpc-0ae47649f0dfc8b6a"
 }

# Associate the newly created route tables to the subnets
 resource "aws_route_table_association" "public-route-1-association" {
   route_table_id = aws_route_table.public-route-table.id
   subnet_id      = "subnet-0e4735713790af595"
 }
resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = "subnet-06db5e975a01e1b3e"
}
resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = "subnet-0252ce56fe6537a34"
}
resource "aws_route_table_association" "private-route-2-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = "subnet-08d2c8eb2a0739e99"
}

#Elastic IP
 resource "aws_eip" "elastic-ip-for-nat-gw" {
   vpc                       = true
   associate_with_private_ip = "10.0.0.5"
 }

 #NAT gateway
 resource "aws_nat_gateway" "nat-gw" {
   allocation_id = aws_eip.elastic-ip-for-nat-gw.id
   subnet_id     = "subnet-0e4735713790af595"
   depends_on    = [aws_eip.elastic-ip-for-nat-gw]
 }
 resource "aws_route" "nat-gw-route" {
   route_table_id         = aws_route_table.private-route-table.id
   nat_gateway_id         = aws_nat_gateway.nat-gw.id
   destination_cidr_block = "0.0.0.0/0"
 }

# #Creating internet Gateway
# resource "aws_internet_gateway" "test-igw" {
#   vpc_id = aws_vpc.test-vpc.id

#   tags = {
#     Name = "igw"
#   }
# }

# Route the public subnet traffic through the Internet Gateway
resource "aws_route" "public-internet-igw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = "igw-00ee4ca30b5d55f8c"
  destination_cidr_block = "0.0.0.0/0"
}

 resource "aws_ecs_cluster" "prod" {
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
      "name": "NGINX",
      "image": "bikigrg/nginx_proxy:latest",
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
          "containerPort": 80
        }
      ]
    },
    {
      "name": "GEST-App",
      "image": "bikigrg/gest_app:latest",
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
  memory                   = "2048"
  cpu                      = "1024"
  execution_role_arn       = "arn:aws:iam::717491011807:role/ECSTaskExec"
  task_role_arn            = "arn:aws:iam::717491011807:role/ECSTaskExec"
}

# ECS Service
resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "url-ecs-service"
  cluster              = aws_ecs_cluster.prod.id
  task_definition      = aws_ecs_task_definition.aws-django-task.arn
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets = [
       "subnet-0252ce56fe6537a34",
       "subnet-08d2c8eb2a0739e99"
    ]
    assign_public_ip = false
    security_groups  = [aws_security_group.ecs.id]
  }
   load_balancer {
    target_group_arn = aws_lb_target_group.django-app.arn
    container_name   = "NGINX"
    container_port   = 80
  }
}


resource "aws_cloudwatch_metric_alarm" "djangomonitor" {
 alarm_name                = "autoscaling-instance"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  threshold                 = "1"
  alarm_description         = "Alarm to check if autoscaling is needed"
  insufficient_data_actions = []
  metric_query {
    id          = "customMetric"
    expression  = "IF(m1 > 70, 1, 0) OR IF(m2 > 75, 1, 0)"
    label       = "custom metric"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "CPUUtilization"
      namespace   = "AWS/ECS"
      period      = "120"
      stat        = "Average"
      unit        = "Percent"
      
      dimensions = {
        ecs_cluster_name = "prod"
        ServiceName = "url-ecs-service"
      }
    }
  }
  metric_query {
    id = "m2"

    metric {
       metric_name = "MemoryUtilization"
      namespace   = "AWS/ECS"
      period      = "120"
      stat        = "Average"
      unit        = "Percent"

      dimensions = {
        ecs_cluster_name = "prod"
        ServiceName = "url-ecs-service"
      }
    }
  }
}