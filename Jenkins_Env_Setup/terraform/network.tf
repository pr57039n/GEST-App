#SUBNET
resource "aws_subnet" "Kura6_SUBNET" {
  vpc_id                  = aws_vpc.Kura6_VPC.id
  cidr_block              = "172.20.0.0/18"
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
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Kura6_GATEWAY.id
  }
}

#ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "Kura6_Association" {
  subnet_id      = aws_subnet.Kura6_SUBNET.id
  route_table_id = aws_route_table.Kura6_ROUTE.id
}
