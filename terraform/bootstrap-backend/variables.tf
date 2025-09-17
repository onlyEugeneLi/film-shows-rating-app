# ============================================= #
# ---------  Global variables: START  --------- #


variable "aws_region" {
  description = "Enter AWS region"
  type        = string
  default     = ""
}

# ---------   Global variables: END   --------- #
#################################################



# ============================================= #
# ---------          S3: START        --------- #

variable "s3_bucket_name" {
  description = "Name the AWS S3 bucket for remote backend state storage"
  type        = string
}

variable "kms_key_alias" {
  description = "Set the alias (name) of the KMS key. The name must start with 'alias/'"
  type        = string
}

# ---------          S3: END          --------- #
#################################################



# ============================================= #
# ---------       DynamoDB: START     --------- #


variable "dynamobd_table_name" {
  type = string
}


# ---------       DynamoDB: END       --------- #
#################################################