# EC2 - Public
resource "aws_instance" "bastion_ec2" {
    ami = "ami-0574da719dca65348"
    instance_type = "t2.micro"
    subnet_id = "subnet-0e4735713790af595"
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.bastion-ssh.id]
    user_data = "${file("dockerserver.sh")}"

    tags = {
        Name : "Bastion Host"
    }
}

# EC2 - Private Subnet
resource "aws_instance" "private_ec2_1" {
    ami = "ami-0574da719dca65348"
    instance_type = "t3.medium"
    subnet_id = "subnet-0252ce56fe6537a34"
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.ec2_access.id]
    user_data = "${file("dockerserver.sh")}"

    tags = {
        Name : "Docker Server 1"
    }
}

resource "aws_instance" "private_ec2_2" {
    ami = "ami-0574da719dca65348"
    instance_type = "t3.medium"
    subnet_id = "subnet-08d2c8eb2a0739e99"
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
  vpc_id = "vpc-0ae47649f0dfc8b6a"
 

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

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [aws_security_group.bastion-ssh.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}

#Bastion host SSH
resource "aws_security_group" "bastion-ssh" {
  name        = "bastion_security_group"
  description = "SSH into public to private"
  vpc_id      = "vpc-0ae47649f0dfc8b6a"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
  vpc_id      = "vpc-0ae47649f0dfc8b6a"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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