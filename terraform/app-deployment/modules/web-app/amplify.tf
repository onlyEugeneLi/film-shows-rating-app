# Relevant values:
# - AWS Region
# - Relevant S3 Buckets

resource "aws_amplify_app" "amplify_app" {
  count      = var.create_amplify_app ? 1 : 0
  name       = var.app_name
  repository = var.github_repository_url

  # used for GitHub repos
  access_token = var.github_access_token // needed for accessing github repo

  build_spec = file("${path.module}/amplify-spec.yml")
  # Redirects for Single Page Web Apps (SPA)
  # https://docs.aws.amazon.com/amplify/latest/userguide/redirects.html#redirects-for-single-page-web-apps-spa
  # The rewrite makes it appear to the user that they have arrived at the original address

  # Enable auto branch creation
  enable_auto_branch_creation = false
  enable_branch_auto_build    = true
  enable_branch_auto_deletion = false

  custom_rule {
    source    = "/<*>"
    status    = "404"
    target    = "/index.html"
    condition = null
  }

  tags = {
    Name        = "Film Rating Web App"
    Environment = "Production"
  }
}

# PROD branch: main
resource "aws_amplify_branch" "main" {
  count             = var.create_amplify_branch_prod ? 1 : 0
  app_id            = aws_amplify_app.amplify_app[0].id
  branch_name       = var.amplify_branch_prod_name
  stage             = var.amplify_branch_prod_stage
  enable_auto_build = true
  framework         = var.amplify_app_framework
  tags = {
    Branch = var.amplify_branch_prod_name
  }
}
# DEV branch: fix/amplify-index-detection
resource "aws_amplify_branch" "dev" {
  count             = var.create_amplify_branch_dev ? 1 : 0
  app_id            = aws_amplify_app.amplify_app[0].id
  branch_name       = var.amplify_branch_dev_name
  stage             = var.amplify_branch_dev_stage
  enable_auto_build = true
  framework         = var.amplify_app_framework
  tags = {
    Branch = var.amplify_branch_dev_name
  }
}

# Enable Web Application Firewall (WAF)
resource "aws_wafv2_web_acl" "amplify_waf" {
  region = var.aws_waf_region
  name  = "amplify-app-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  # AWS Managed Rule - Core Rule Set
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  # AWS Managed Rule - Known Bad Inputs
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  # AWS Managed Rule - Anonymous IP List
  rule {
    name     = "AWSManagedRulesAnonymousIpList"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesAnonymousIpListMetric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "amplify-waf-metric"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "Amplify WAF"
  }
}

# Associate WAF with Amplify App
resource "aws_wafv2_web_acl_association" "amplify_waf_association" {
  region = var.aws_waf_region
  resource_arn = aws_amplify_app.amplify_app[0].arn
  web_acl_arn  = aws_wafv2_web_acl.amplify_waf.arn
}