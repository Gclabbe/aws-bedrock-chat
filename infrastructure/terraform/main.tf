provider "aws" {
  region = var.aws_region
}

# Lambda function for chat API
resource "aws_lambda_function" "chat_function" {
  function_name    = "${var.project_name}-chat-function"
  handler          = "handlers.chat.lambda_handler"
  runtime          = "python3.9"
  filename         = "../backend/deployment_package.zip"
  source_code_hash = filebase64sha256("../backend/deployment_package.zip")
  role             = aws_iam_role.lambda_role.arn
  timeout          = 30
  memory_size      = 256

  environment {
    variables = {
      LOG_LEVEL = "INFO"
    }
  }
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Policy for Bedrock access
resource "aws_iam_policy" "bedrock_access_policy" {
  name        = "${var.project_name}-bedrock-access"
  description = "Policy for accessing AWS Bedrock models"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "lambda_bedrock" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.bedrock_access_policy.arn
}

# Basic Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# API Gateway REST API
resource "aws_apigateway_rest_api" "chat_api" {
  name        = "${var.project_name}-api"
  description = "API for Bedrock Chat application"
}

# API Gateway resource
resource "aws_apigateway_resource" "chat_resource" {
  rest_api_id = aws_apigateway_rest_api.chat_api.id
  parent_id   = aws_apigateway_rest_api.chat_api.root_resource_id
  path_part   = "chat"
}

# API Gateway method
resource "aws_apigateway_method" "chat_method" {
  rest_api_id   = aws_apigateway_rest_api.chat_api.id
  resource_id   = aws_apigateway_resource.chat_resource.id
  http_method   = "POST"
  authorization_type = "NONE"
}

# API Gateway integration
resource "aws_apigateway_integration" "lambda_integration" {
  rest_api_id             = aws_apigateway_rest_api.chat_api.id
  resource_id             = aws_apigateway_resource.chat_resource.id
  http_method             = aws_apigateway_method.chat_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.chat_function.invoke_arn
}

# API Gateway deployment
resource "aws_apigateway_deployment" "api_deployment" {
  depends_on = [
    aws_apigateway_integration.lambda_integration
  ]

  rest_api_id = aws_apigateway_rest_api.chat_api.id
  stage_name  = var.environment

  lifecycle {
    create_before_destroy = true
  }
}

# Lambda permission for API Gateway
resource "aws_lambda_permission" "api_gw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.chat_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigateway_rest_api.chat_api.execution_arn}/*/*"
}

# S3 bucket for frontend
resource "aws_s3_bucket" "frontend_bucket" {
  bucket = "${var.project_name}-${var.environment}-frontend"
}

# S3 bucket policy
resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.frontend_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = ["s3:GetObject"]
        Effect    = "Allow"
        Resource  = "${aws_s3_bucket.frontend_bucket.arn}/*"
        Principal = "*"
      }
    ]
  })
}

# S3 website configuration
resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket = aws_s3_bucket.frontend_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}
