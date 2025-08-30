# - Amplify -
variable "create_amplify_app" {
  type        = bool
  default     = true
  description = "Conditional creation of AWS Amplify Web Application"
}
variable "app_name" {
  type        = string
  default     = "film-shows-rating-app"
  description = "The name of the Amplify Application"
}

variable "github_repository_url" {
  type        = string
  default     = "https://github.com/onlyEugeneLi/film-shows-rating-app.git"
  description = "URL for the existing repo"

}
variable "github_access_token" {
  type        = string
  description = "Optional GitHub access token. Only required if using GitHub repo."

}
variable "tca_amplify_app_framework" {
  type    = string
  default = "React"

}
variable "create_tca_amplify_branch_main" {
  type        = bool
  default     = true
  description = "Conditional creation of main branch for amplify app"

}
variable "tca_amplify_branch_main_name" {
  type    = string
  default = "main"
}
variable "tca_amplify_branch_main_stage" {
  type    = string
  default = "PRODUCTION"

}
variable "create_tca_amplify_branch_dev" {
  type        = bool
  default     = true
  description = "Conditional creation of dev branch for amplify app"

}
variable "tca_amplify_branch_dev_name" {
  type    = string
  default = "dev"
}
variable "tca_amplify_branch_dev_stage" {
  type    = string
  default = "DEVELOPMENT"

}

variable "create_tca_amplify_domain_association" {
  type    = bool
  default = false

}
variable "tca_amplify_app_domain_name" {
  type        = string
  default     = "example.com"
  description = "The name of your domain. Ex. naruto.ninja"

}