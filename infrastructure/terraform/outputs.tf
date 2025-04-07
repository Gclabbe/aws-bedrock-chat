output "api_gateway_url" {
  description = "URL of the API Gateway endpoint"
  value       = "${aws_apigateway_deployment.api_deployment.invoke_url}/${aws_apigateway_resource.chat_resource.path_part}"
}

output "frontend_website_url" {
  description = "URL of the S3 website hosting the frontend"
  value       = aws_s3_bucket_website_configuration.frontend_website.website_endpoint
}

output "frontend_bucket_name" {
  description = "Name of the S3 bucket for frontend deployment"
  value       = aws_s3_bucket.frontend_bucket.id
}
