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
      bucket          = "s3-web-app-tf-remote-backend-bucket"
      key             = "state/terraform.tfstate" # directory path
      region          = "us-east-2"
      # dynamodb_table  = "dynamodb-web-app-tf-state-locking-table" # Deprecated - will be made unavailable by Terraform in the future
      use_lockfile    = true # Recommended by Terraform - Enable state locking via S3
      encrypt         = true
    }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.8"
    }
  }
}