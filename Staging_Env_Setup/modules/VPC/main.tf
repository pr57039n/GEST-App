# # Create VPC and resources

# #VPC
# resource "aws_vpc" "VPC" {
#     cidr_block = var.cidr_block
#     enable_dns_hostnames = true
#     enable_dns_support = true

#     tags = {
#         Name = "${var.project_name}-vpc"
#     }
# }


# # Availability Zones
# data "aws_availability_zones" "availability_zones" {}

# # Public Subnet in AZ 1
# resource "aws_subnet" "public_subnet_az1" {
#     vpc_id = aws_vpc.VPC.id
#     cidr_block = var.public_subnet_az1_cidr
#     availability_zone = data.aws_availability_zones.availability_zones.names[0]
#     map_public_ip_on_launch = true
    
#     tags = {
#         Name = "public subnet az1"
#     }
  
# }

# # Private Subnet in AZ 1
# resource "aws_subnet" "private_subnet_az1" {
#     vpc_id = aws_vpc.VPC.id
#     cidr_block = var.private_subnet_az1_cidr
#     availability_zone = data.aws_availability_zones.availability_zones.names[0]
#     map_public_ip_on_launch = false
    
#     tags = {
#         Name = "private subnet az1"
#     }
  
# }


# # Public Subnet in AZ 2
# resource "aws_subnet" "public_subnet_az2" {
#     vpc_id = aws_vpc.VPC.id
#     cidr_block = var.public_subnet_az2_cidr
#     availability_zone = data.aws_availability_zones.availability_zones.names[1]
#     map_public_ip_on_launch = true

#     tags = {
#         Name = "public subnet az2"
#     }
# }



# # Private Subnet in AZ 2
# resource "aws_subnet" "private_subnet_az2" {
#     vpc_id = aws_vpc.VPC.id
#     cidr_block = var.private_subnet_az2_cidr
#     availability_zone = data.aws_availability_zones.availability_zones.names[1]
#     map_public_ip_on_launch = false
# }



# Route Table - Public 
resource "aws_route_table" "public_route_table" {
    vpc_id = "vpc-0ae47649f0dfc8b6a"

    /*route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }

    tags = {
        Name = "public route table"
    }*/
}



# Route Association - public subnets to public route table 

resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
    subnet_id = "subnet-0e4735713790af595"
    route_table_id = aws_route_table.public_route_table.id 
}

resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
    subnet_id = "subnet-06db5e975a01e1b3e"
    route_table_id = aws_route_table.public_route_table.id
}


# Route Table - Private  
resource "aws_route_table" "private_route_table" {
    vpc_id = "vpc-0ae47649f0dfc8b6a"
}

# Route Association - private subnets to private route table 
resource "aws_route_table_association" "private_subnet_az1_route_table_assocation" {
    subnet_id = "subnet-0252ce56fe6537a34"
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_az2_route_table_assocation" {
    subnet_id = "subnet-08d2c8eb2a0739e99"
    route_table_id = aws_route_table.private_route_table.id
}


# # Internet Gateway 
# resource "aws_internet_gateway" "internet_gateway" {
#     vpc_id = aws_vpc.VPC.id

#     tags = {
#         Name = "${var.project_name}-igw"
#     }
# }


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
   route_table_id         = aws_route_table.private_route_table.id
   nat_gateway_id         = aws_nat_gateway.nat-gw.id
   destination_cidr_block = "0.0.0.0/0"
 }


resource "aws_route" "public-internet-igw-route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = "igw-00ee4ca30b5d55f8c"
  destination_cidr_block = "0.0.0.0/0"
}
