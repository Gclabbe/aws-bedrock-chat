#!/bin/bash
# Script to deploy AWS Bedrock Chat application

set -e

# Configuration variables
ENVIRONMENT=${1:-dev}
AWS_REGION=${2:-us-east-1}
PROJECT_ROOT=$(pwd)

echo "Deploying AWS Bedrock Chat to $ENVIRONMENT environment in $AWS_REGION region"

# Build and package backend
echo "Building backend..."
cd $PROJECT_ROOT/backend
pip install -r requirements.txt -t ./package
cd package
zip -r ../deployment_package.zip .
cd ..
zip -g deployment_package.zip -r src

# Deploy infrastructure using Terraform
echo "Deploying infrastructure..."
cd $PROJECT_ROOT/infrastructure/terraform
terraform init
terraform apply -var="environment=$ENVIRONMENT" -var="aws_region=$AWS_REGION" -auto-approve

# Get outputs from Terraform
API_URL=$(terraform output -raw api_gateway_url)
BUCKET_NAME=$(terraform output -raw frontend_bucket_name)

# Build frontend with API URL
echo "Building frontend..."
cd $PROJECT_ROOT/frontend
echo "REACT_APP_API_ENDPOINT=$API_URL" > .env
npm install
npm run build

# Deploy frontend to S3
echo "Deploying frontend to S3..."
aws s3 sync build/ s3://$BUCKET_NAME/ --delete

# Output application URL
FRONTEND_URL=$(terraform -chdir=$PROJECT_ROOT/infrastructure/terraform output -raw frontend_website_url)
echo "Deployment complete!"
echo "Frontend URL: http://$FRONTEND_URL"
echo "API URL: $API_URL"
