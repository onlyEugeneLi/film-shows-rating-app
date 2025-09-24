# ============================================= #
# ---------          S3: START        --------- #


# # KMS key
# resource "aws_kms_key" "bootstrap_s3_bucket_kms_key" {
#   description             = "This key is used to encrypt bucket objects"
#   deletion_window_in_days = 10
# }

# # Set alias for KMS key resource
# resource "aws_kms_alias" "bootstrap_s3_bucket_kms_key_alias" {
#   name          = var.bootstrap_s3_bucket_kms_key_alias
#   target_key_id = aws_kms_key.bootstrap_s3_bucket_kms_key.key_id
# }

# create state-files S3 buket 
resource "aws_s3_bucket" "bootstrap_s3_bucket" {
  bucket = var.s3_bucket_name

  # Prevent s3 bucket from being destroyed by Terraform
  lifecycle {
    prevent_destroy = true
    // if needed to be removed, change to false here
  }
}

# enable S3 bucket versioning
resource "aws_s3_bucket_versioning" "bootstrap_s3_bucket_versioning" {
  bucket = aws_s3_bucket.bootstrap_s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# enable S3 bucket encryption 
resource "aws_s3_bucket_server_side_encryption_configuration" "bootstrap_s3_bucket_encryption" {
  bucket = aws_s3_bucket.bootstrap_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      # kms_master_key_id = aws_kms_key.bootstrap_s3_bucket_kms_key.arn # Only required if `sse_algorithm` is "aws:kms"
      sse_algorithm     = "AES256" # "aws:kms"
    }
    bucket_key_enabled = true
  }
}

# block S3 bucket public access
resource "aws_s3_bucket_public_access_block" "bootstrap_s3_bucket_acl" {
  bucket                  = aws_s3_bucket.bootstrap_s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ---------          S3: END          --------- #
#################################################





# ============================================= #
# ---------       DynamoDB: START     --------- #

# resource "aws_dynamodb_table" "bootstrap_dynamodb_table" {
#   name         = var.dynamobd_table_name
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }

# ---------       DynamoDB: END       --------- #
#################################################