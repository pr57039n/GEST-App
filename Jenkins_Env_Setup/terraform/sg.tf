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