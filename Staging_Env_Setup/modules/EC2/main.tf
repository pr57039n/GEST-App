# EC2 - Private Subnet
resource "aws_instance" "private_ec2_1" {
    ami = "ami-0574da719dca65348"
    instance_type = "t2.micro"
    subnet_id = var.private_subnet_az1_id
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.ec2_access.id]
    user_data = "${file("dockerserver.sh")}"

    tags = {
        Name : "Docker Server 1"
    }
}

resource "aws_instance" "private_ec2_2" {
    ami = "ami-0574da719dca65348"
    instance_type = "t2.micro"
    subnet_id = var.private_subnet_az2_id
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.ec2_access.id]
    user_data = "${file("dockerserver.sh")}"

    tags = {
        Name : "Docker Server 2"
    }
}


# EC2 Security Group (ALB -> EC2)
resource "aws_security_group" "ec2_access" {
  name        = "ec2 security group"
  description = "Allows inbound access from ALB only"
  vpc_id = var.vpc_id
 

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [aws_security_group.load-balancer.id]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}

# ALB Security Group (Traffic Internet -> ALB)
resource "aws_security_group" "load-balancer" {
  name        = "load_balancer_security_group"
  description = "Controls access to the ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*output "private_ec2_1_ip" {
    value = aws_instance.private_ec2_1.private_ip
}

output "private_ec2_2_ip" {
    value = aws_instance.private_ec2_2.private_ip
}*/