# Relevant values:
# - AWS Region
# - Relevant S3 Buckets

resource "aws_amplify_app" "amplify_app" {
  count                    = var.create_amplify_app ? 1 : 0
  name                     = var.app_name
  repository               = var.github_repository_url
  enable_branch_auto_build = true

  # used for GitHub repos
  access_token         = var.github_access_token // needed for accessing github repo

  build_spec = file("${path.root}/../module/web-app/amplify-spec.yml")
  # Redirects for Single Page Web Apps (SPA)
  # https://docs.aws.amazon.com/amplify/latest/userguide/redirects.html#redirects-for-single-page-web-apps-spa
  # The rewrite makes it appear to the user that they have arrived at the original address
  custom_rule {
    source = "/<*>"
    status = "200"
    target = "/index.html"
    condition = null
  }
}

resource "aws_amplify_branch" "tca_amplify_branch_dev" {
  count       = var.create_amplify_branch_dev ? 1 : 0
  app_id      = aws_amplify_app.amplify_app[0].id
  branch_name = var.amplify_branch_dev_name
  stage     = var.amplify_branch_dev_stage

  environment_variables = {
    ENV = "dev"
  }
}