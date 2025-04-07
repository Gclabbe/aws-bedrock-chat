variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "bedrock-chat"
}

variable "environment" {
  description = "Deployment environment (dev, prod, etc)"
  type        = string
  default     = "dev"
}
