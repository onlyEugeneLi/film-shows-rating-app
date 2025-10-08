# Web app module resource
module "web-app" {
  source = "./modules/web-app"
  # Include GitHub Access Token in the command line
  # terraform apply -var "github_access_token=<paste your token here>" -auto-approve
  github_access_token = var.github_access_token
}

# Configure terraform environment
# Set up S3 backend for Terraform state
terraform {

  required_version = "~> 1.12"


  # S3 Backend configuration (Uncomment after S3 bucket provision, run just `terraform init`)
  backend "s3" {
    bucket       = var.s3_remote_backend_bucket_name
    key          = var.s3_backend_path # directory path
    region       = var.aws_region
    use_lockfile = true # Recommended by Terraform - Enable state locking via S3
    encrypt      = true
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.8"
    }
  }
}