# #S3 bucket (still looking to add object lock, access control list, and kms)
# resource "aws_s3_bucket" "tfstate" {
#     bucket = "k6application"
#     force_destroy = true
#     #object_lock_configuration {
#         #object_lock_enabled = "Enabled"
#     #}
#     tags = {
#         Name = "S3 Remote Terraform State Store"
#     }
  
# }

# # enable versioning of the state file 
# resource "aws_s3_bucket_versioning" "tfstate_versioning" {
#   bucket = aws_s3_bucket.tfstate.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# #encrypt sensitive data in the state file 
# resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_encryption" {
#     bucket = aws_s3_bucket.tfstate.id
#     rule {
#             apply_server_side_encryption_by_default {
#                 sse_algorithm = "AES256"
#             }
#         }
# }

# #awsresource "aws_s3_bucket_acl" "tfstate" {
#     #bucket = aws_s3_bucket.tfstate.id
#     #acl = "private"
# #}

# # Dynamo DB to lock the state file 
# resource "aws_dynamodb_table" "terraform-lock-db" {
#     name           = "terraform_state"
#     read_capacity  = 5
#     write_capacity = 5
#     hash_key       = "LockID"
#     attribute {
#         name = "LockID"
#         type = "S"
#     }
#     tags = {
#         "Name" = "DynamoDB Terraform State Lock Table"
#     }
# }