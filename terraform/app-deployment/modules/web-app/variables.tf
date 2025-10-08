# ============================================= #
# --------------  Amplify: START  ------------- #
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
variable "amplify_app_framework" {
  type        = string
  default     = "Web"
  description = "Framework for the app"
}

# Github access
variable "github_repository_url" {
  type        = string
  default     = "https://github.com/onlyEugeneLi/film-shows-rating-app.git"
  description = "URL for the existing repo"
}
variable "github_access_token" {
  type = string

  description = "GitHub access token, required when using GitHub repo."
}

# Dev branch
variable "create_amplify_branch_dev" {
  type        = bool
  default     = true
  description = "Conditional creation of dev branch for amplify app"
}
variable "amplify_branch_dev_name" {
  type    = string
  default = "fix/amplify-index-detection"
}
variable "amplify_branch_dev_stage" {
  type    = string
  default = "DEVELOPMENT"
}

# Prod branch
variable "create_amplify_branch_prod" {
  type        = bool
  default     = false
  description = "Conditional creation of prod branch for amplify app"
}
variable "amplify_branch_prod_name" {
  type    = string
  default = "main"
}
variable "amplify_branch_prod_stage" {
  type    = string
  default = "PRODUCTION"
}
# ---------------  Amplify: END  -------------- #
# ============================================= #

# ============================================= #
# ---------------  Lambda: START  ------------- #
variable "lambda_function_name" {
  type        = string
  default     = "write-web-input-to-dynamodb"
  description = "The name of the lambda function that stores data input from web interface to DynamoDB table."
}
# ----------------  Lambda: END  -------------- #
# ============================================= #

# - API Gateway -
