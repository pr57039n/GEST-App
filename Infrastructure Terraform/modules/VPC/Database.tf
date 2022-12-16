resource "aws_db_instance" "django_db" {
# Allocating the storage for database instance.
  allocated_storage    = 10
# Declaring the database engine and engine_version
  engine               = var.engine
  engine_version       = var.engine_version
# Declaring the instance class
  instance_class       = var.instance_class
  db_name              = var.dbname
# User to connect the database instance 
  username             = var.username
# Password to connect the database instance 
  password             = var.password
  #Declares if the RDS instance is multi AZ
  multi_az = "true"
  #Associates the subnets to the database
  db_subnet_group_name = aws_db_subnet_group.PrivateSubnets.name
  #Port the DB will use
  port = 3306
  #Accessibility to the database
  publicly_accessible = "true"
}

resource "aws_db_subnet_group" "PrivateSubnets" {
  name = "private_subnets"
  subnet_ids = [aws_subnet.private_subnet_az1.id, aws_subnet.private_subnet_az2.id]
}

resource "aws_s3_bucket" "DjangoBucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "PrivateBucket" {
  bucket = var.bucket_name
  acl = "private"
}
