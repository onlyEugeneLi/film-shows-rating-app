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
1. CD pipeline
1. EC2 Migration
1. VPN access via home network only
1. Add Chinese language webpage and link to switch between languages


# Terraform configurations

**Configuration Directory Structure**

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

## Amplify App

## S3 Terraform Backend Bucket

Set up Terraform remote backend state storage in S3 bucket

backend.tf

locals.tf

## Lambda function

## API Gateway

## DynamoDB Table for Web App Data

