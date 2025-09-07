# API gateway definition - v1 REST API

# REST API configuration
resource "aws_api_gateway_rest_api" "api-gtw-invoke-lambda" {
  name        = "api-gtw-invoke-lambda"
  description = "API endpoint used to connnect HTML web and lambda function"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# API Gateway resource creation
resource "aws_api_gateway_resource" "api-gtw-invoke-lambda-resource" {
  parent_id   = aws_api_gateway_rest_api.api-gtw-invoke-lambda.root_resource_id
  path_part   = "/"
  rest_api_id = aws_api_gateway_rest_api.api-gtw-invoke-lambda.id
}

# API method
resource "aws_api_gateway_method" "api-gtw-invoke-lambda-method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.api-gtw-invoke-lambda-resource.id
  rest_api_id   = aws_api_gateway_rest_api.api-gtw-invoke-lambda.id
}

# Custom response
resource "aws_api_gateway_method_response" "api-gtw-invoke-lambda-method-response" {
  rest_api_id = aws_api_gateway_rest_api.api-gtw-invoke-lambda.id
  resource_id = aws_api_gateway_resource.api-gtw-invoke-lambda-resource.id
  http_method = aws_api_gateway_method.api-gtw-invoke-lambda-method.http_method
  status_code = "200"

  # Enable CORS
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

}

# Connect to Lambda
resource "aws_api_gateway_integration" "api-gtw-invoke-lambda-integration" {
  http_method             = aws_api_gateway_method.api-gtw-invoke-lambda-method.http_method
  resource_id             = aws_api_gateway_resource.api-gtw-invoke-lambda-resource.id
  rest_api_id             = aws_api_gateway_rest_api.api-gtw-invoke-lambda.id
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.lambda-function-web-input-dynamodb.invoke_arn
}

# Integration response
resource "aws_api_gateway_integration_response" "api-gtw-invoke-lambda-integration-response" {
  rest_api_id = aws_api_gateway_rest_api.api-gtw-invoke-lambda.id
  resource_id = aws_api_gateway_resource.api-gtw-invoke-lambda-resource.id
  http_method = aws_api_gateway_method.api-gtw-invoke-lambda-method.http_method
  status_code = aws_api_gateway_method_response.api-gtw-invoke-lambda-method-response.status_code

  response_templates = {
    "application/json" = jsonencode({ "LambdaValue" = "$input.path('$').body", "data" = "Custom Value" })
  }

  # Enable CORS
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_integration.api-gtw-invoke-lambda-integration
  ]

}

# Deploy API
resource "aws_api_gateway_deployment" "api-gtw-invoke-lambda-deployment" {
  rest_api_id = aws_api_gateway_rest_api.api-gtw-invoke-lambda.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api-gtw-invoke-lambda-resource.id,
      aws_api_gateway_method.api-gtw-invoke-lambda-method.id,
      aws_api_gateway_integration.api-gtw-invoke-lambda-integration.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.api-gtw-invoke-lambda-integration
  ]
}

# Create a stage
resource "aws_api_gateway_stage" "api-gtw-invoke-lambda" {
  deployment_id = aws_api_gateway_deployment.api-gtw-invoke-lambda-deployment
  rest_api_id   = aws_api_gateway_rest_api.api-gtw-invoke-lambda.id
  stage_name    = "dev"
}

# API gateway to Lambda permission
resource "aws_lambda_permission" "api-gtw-invoke-lambda-permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-function-web-input-dynamodb.function_name
  principal     = "apigateway.amazonaws.com"
  statement_id  = "AllowExecutionFromAPIGateway"
  source_arn    = "${aws_api_gateway_rest_api.api-gtw-invoke-lambda.execution_arn}/*/*/*"
}

# Provide URL to include in HTML JS script
output "invoke_url" {
  value = aws_api_gateway_deployment.api-gtw-invoke-lambda-deployment.invoke_url
}