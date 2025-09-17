# Film Tracker Web App

link: https://mvp.do6ll7rrdt0e8.amplifyapp.com/

Similar application: Ratings form 

Objectives:

- Host a static webpage
- A way to invoke the data handling functionality
- A way to process request (save data, serve JSON response)
- Database to store / return the result
- A way to handle permissions

## Serverless architecture

AWS Amplify: host a static webpage

AWS Lambda: a way to process the event (calculation, logic)

AWS API Gateway: A way to invoke (trigger the function to run) the math functionality

Database: AWS DynamoDB (NoSQL)

AWS IAM: permissions — give AWS Lambda function permissions to write AWS DynamoDB table

# Next steps

[Amplify Web form App HTML](https://www.youtube.com/watch?v=7m_q1ldzw0U)

[AWS Blog - Web contact form deployment in Serverless Architecture](https://aws.amazon.com/blogs/architecture/create-dynamic-contact-forms-for-s3-static-websites-using-aws-lambda-amazon-api-gateway-and-amazon-ses/)

[Terraform deployment code example](https://github.com/novekm/amazon-transcribe-call-analytics-quickstart/tree/main/terraform-deployment)

1. ✅ Add html web form code
1. ✅ Configure infrastructure (Amplify, DynamoDB, API gateway, roles, IAMs, cognito)
1. ✅ Successful infra deployment
1. ✅ Lambda function python API backend code
1. ✅ Test run app
1. CD pipeline: deploy code changes automatically
1. EC2 Migration
1. VPN access via home network only
1. Add Chinese language webpage and link to switch between languages


# Terraform configurations

## Next steps

- 🔁 Use [Bootstrapping method with Makefile](https://medium.com/@owumifestus/automating-terraform-backend-setup-bootstrapping-s3-and-dynamodb-state-aa2d2070e258) to set up the backend infrastructure and use CD pipeline to automate Terraform deployment
  - ✅ Modify terraform directory hierarchy so backend setup is separate from main configuration
    - terraform/modules: web-app and backend
    - terraform/web-app: app deployment
  - ✅ terraform/bootstrapping-backend: s3 bucket and dynamodb table for state locking

- Set up Destroy CD pipeline with parameters
  - Need to set up permission to run terraform from GitHub Action CD pipeline

- Fix: AWS Amplify does not pick up HTML content from GitHub repo

- Test connection between API Gateway and Lambda function, DynamoDB table

---

**Configuration Directory Structure**
```
terraform/ 
|--- main.tf
|--- variables.tf
|--- provider.tf
|--- module/ 
    |--- web-app
        |--- amplify.tf
        |--- api-gateway.tf
        |--- dynamodb.tf
        |--- iam.tf
        |--- lambda.tf
```

## Terraform Remote Backend Setup

References: 

[Bootstrapping method with Makefile](https://medium.com/@owumifestus/automating-terraform-backend-setup-bootstrapping-s3-and-dynamodb-state-aa2d2070e258)

[Migrating Terraform State Between Backends: A Simple Guide](https://terrateam.io/blog/migrating-terraform-state-between-backends#:~:text=be%20stored%20here.-,Scenario%202%3A%20Migrating%20Terraform%20State%20from%20Remote%20Backend%20to%20Local%20Setup,-In%20this%20scenario)
- Migrating from Local to Remote
- Migrating from Remote to Local

[Solving the Terraform Backend Chicken-and-Egg Problem](https://cloudchronicles.blog/blog/Solving-the-Terraform-Backend-Chicken-and-Egg-Problem/)

## Amplify App

Github repo link

branch

rewrite and redirect rules

github access token variable

Apmlify specification file: amplify.yml

## S3 Terraform Backend Bucket

Set up Terraform remote backend state storage in S3 bucket

backend.tf

locals.tf

## Lambda function

Create IAM role for Lambda function

> Need permission to write to DynamoDB table!

Create assume role data block: which format to use?

Format 1:
```
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
```

Format 2:

```
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
}

# Create a lambda function execution role 
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
```

Create zip file using archive_file data block to upload code to Lambda function

Hash the zip file to force update when code changes

### IAM JSON Policy element reference

The Statement element can contain a single statement or an array of individual statements. Each individual statement block must be enclosed in curly braces `{ }`. For multiple statements, the array must be enclosed in square brackets `[ ]`.



## API Gateway

> Embed the API gateway URL in the `index.html` JavaScript code!

Create API gateway configuraiton

creating the API Gateway REST API, resources, methods (including POST for the form data and OPTIONS for CORS), and integrations with the Lambda function

API Gateway deployment

## DynamoDB Table for Web App Data

Create DynamoDB table with primary key

Add attributes 

> NEXT: add state locking 

# CD pipeline

## S3 backend state

Command to deploy S3 bucket for Terraform backend state (used by resource in s3_bucket_backend.tf)

## Link HTML script to API Gateway URL

How to include URL in HTML JS script?
1. Create output variable in api_gateway.tf
2. Reference the output variable in the main.tf file where the module is called
