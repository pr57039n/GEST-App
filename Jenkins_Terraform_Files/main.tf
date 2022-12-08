terraform {
    required_providers {
      aws = {
    source = "hashicorp/aws"
    version = "3.0"
    }
    }
}
#PROVIDER
provider "aws" {
  region = "us-east-1"
}
#VPC
 resource "aws_vpc" "Kura6_VPC" {
    cidr_block = "172.20.0.0/16"
   tags = {
    Name = "Kura6_VPC"
   }
 }
#SUBNET
 resource "aws_subnet" "Kura6_SUBNET" {
    vpc_id = aws_vpc.Kura6_VPC.id
     cidr_block = "172.20.0.0/18" 
     map_public_ip_on_launch = true
    tags = {
      Name = "Kura6_SUBNET"
    } 
 }
#INTERNET GATEWAY
resource "aws_internet_gateway" "Kura6_GATEWAY" {
  vpc_id = aws_vpc.Kura6_VPC.id
}
#ROUTE TABLE
 resource "aws_route_table" "Kura6_ROUTE" {
   vpc_id = aws_vpc.Kura6_VPC.id
   route  {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.Kura6_GATEWAY.id
   } 
 }

 #ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "Kura6_Association" {
  subnet_id = aws_subnet.Kura6_SUBNET.id
  route_table_id = aws_route_table.Kura6_ROUTE.id
}

#INSTANCES
resource "aws_instance" "Kura6_Jenkins" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  key_name = "JenKey"
  subnet_id = aws_subnet.Kura6_SUBNET.id
  vpc_security_group_ids = [aws_security_group.Kura6_Security.id]
  user_data = "${file("JenkinsInstall.txt")}"
  tags = {
    Name = "Kura6_Jenkins"
  }
}

resource "aws_instance" "Kura6_Docker" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  key_name = "JenKey"
  subnet_id = aws_subnet.Kura6_SUBNET.id
  vpc_security_group_ids = [aws_security_group.Kura6_Security.id]
  user_data = "${file("DockerInstall.txt")}"
  tags = {
    Name = "Kura6_Docker"
  }
}

resource "aws_instance" "Kura6_Terraform" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  key_name = "JenKey"
  subnet_id = aws_subnet.Kura6_SUBNET.id
  vpc_security_group_ids = [aws_security_group.Kura6_Security.id]
  user_data = "${file("terraformInstall.txt")}"
  tags = {
    Name = "Kura6_Terraform"
  }
}
#SECURITY GROUPS
resource "aws_security_group" "Kura6_Security" {
  name = "Kura6_Security"
  description = "Security group to open certain ports"
  vpc_id = aws_vpc.Kura6_VPC.id
  
  ingress  {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress  {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  } 
}