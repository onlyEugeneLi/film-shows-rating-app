###################################################################
#    Create S3 backend bucket to store terraform state file       #
###################################################################

# How can I create S3 without error before using it here? 
# - You cannot do this in pure Terraform alone.
# A Python/Bash script or tool must handle the two-step process for you.
# Here we just manually un-comment backend migration code when S3 and dynamoDB resource provision code are executed. 
# We can explore automated options in a branch 

terraform {
  required_version = "~> 1.12"
  # # S3 Backend configuration (Uncomment after S3 bucket provision, run just `terraform init`)
  #   backend "s3" {
  #     bucket          = local.s3_backend_bucket_name
  #     key             = local.s3_backend_state_key # directory path
  #     region          = var.aws_region
  #     # dynamodb_table  = "backend" # Deprecated
  #     use_lockfile    = local.s3_backend_use_lockfile
  #     encrypt         = local.s3_backend_encrypt
  #   }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.8"
    }
  }
}

# Need to remove this in CD pipeline branch 
resource "aws_s3_bucket" "app_s3_backend_bucket" {
  bucket        = local.s3_backend_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "app_s3_backend_bucket_vesioning" {
  bucket = aws_s3_bucket.app_s3_backend_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_s3_backend_bucket_server_encryption" {
  bucket = aws_s3_bucket.app_s3_backend_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
