variable "aws_region" {
  type = string
}

# dummy variable to take input in the command line
variable "github_access_token" {

}

# S3 remote backend bucket
variable "s3_remote_backend_bucket_name" {
  description = "Provide S3 remote backend bucket a unique name"
  type        = string
}

variable "s3_backend_path" {
  description = "Set a path for the S3 bucket"
  type        = string
}