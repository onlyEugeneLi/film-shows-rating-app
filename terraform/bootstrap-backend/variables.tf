# --------- Global variables: start --------- #

variable "aws_region" {
    description = "Enter AWS region"
    type = string
    default = ""
}

# --------- Global variables: end --------- #




# --------- S3 variables: start --------- #

variable "s3_bucket_name" {
    description = "Name the AWS S3 bucket for remote backend state storage"
    type = string
}

# --------- S3 variables: end  --------- #
