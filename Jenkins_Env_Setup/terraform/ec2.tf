resource "aws_instance" "Kura6_Docker" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  key_name = "Ktest"
  subnet_id = aws_subnet.Kura6_SUBNET.id
  vpc_security_group_ids = [aws_security_group.Kura6_Security.id]
  user_data = "${file("../scripts/DockerInstall.txt")}"
  tags = {
    Name = "Kura6_Docker"
  }
}

resource "aws_instance" "Kura6_Terraform" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  key_name = "Ktest"
  subnet_id = aws_subnet.Kura6_SUBNET.id
  vpc_security_group_ids = [aws_security_group.Kura6_Security.id]
  user_data = "${file("../scripts/terraformInstall.txt")}"
  tags = {
    Name = "Kura6_Terraform"
  }
}

#INSTANCES
resource "aws_instance" "Kura6_Jenkins" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  key_name = "Ktest"
  subnet_id = aws_subnet.Kura6_SUBNET.id
  vpc_security_group_ids = [aws_security_group.Kura6_Security.id]
  user_data = "${file("../scripts/JenkinsInstall.txt")}"
  tags = {
    Name = "Kura6_Jenkins"
  }
}