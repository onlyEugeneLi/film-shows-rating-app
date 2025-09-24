locals {
  # S3 backend attributes
  s3_backend_bucket_name  = "app-tf-backend-bucket-55637"
  s3_backend_state_key    = "state/terraform.tfstate"
  s3_backend_use_lockfile = true
  s3_backend_encrypt      = true
}