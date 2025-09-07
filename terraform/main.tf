module "web-app" {
  source = "./modules/web-app"
  # Include GitHub Access Token in the command line
  # terraform apply -var "github_access_token=<paste your token here>"
  github_access_token = var.github_access_token
}