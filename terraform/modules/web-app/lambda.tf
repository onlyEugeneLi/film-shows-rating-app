
# --- Main: Lambda function resource ---

resource "aws_lambda_function" "lambda-function-web-input-dynamodb" {
  # Source code location
  filename = data.archive_file.lambda_code

  # Lambda basic metadata
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role

  runtime = "python3.12"
  handler = "backend-lambda.lambda_handler" # The function intended to be triggered by the API -- "<code_file_name>.<function_name>"

  source_code_hash = data.archive_file.lambda_code.output_base64sha256 # attribute will change whenever you update the code contained in the archive, which lets Lambda know that there is a new version of your code available

  environment {
    variables = {
      ENVIRONMENT = "dev"
      LOG_LEVEL   = "info"
    }
  }

  tags = {
    Environment = "dev"
    Application = "film-shows-rating-app"
  }
}

# --- Dependencies: arguments configuration --- 

# Reference IAM role for Lambda execution from AWS template
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }

  # Provide Write permission to DynamoDB table
  statement {
    sid    = "ReadWriteDynamoDBTable"
    effect = "Allow"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]

    resources = [aws_dynamodb_table.dynamodb-table.arn]
  }
}

# Create a lambda function execution role 
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Policy attachment
resource "aws_iam_role_policy_attachment" "lambda_exec_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Package the Lambda function code
data "archive_file" "lambda_code" {
  type        = "zip"
  source_file = "${path.module}/lambda-functions/"
  output_path = "${path.module}/lambda-functions/backend-lambda.zip"
}
