# App infra region
provider "aws" {
  region = var.aws_region
}

# WAF for Amplify MUST be in us-east-1
provider "aws" {
  alias  = "aws_waf_region"
  region = "us-east-1"
}