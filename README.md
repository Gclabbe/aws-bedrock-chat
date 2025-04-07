# AWS Bedrock Chat Application

A full-stack application that leverages AWS Bedrock to create a conversational AI interface similar to ChatGPT.

## Features

- Interactive chat interface
- Support for multiple AWS Bedrock models (Claude, Llama 2, Amazon Titan)
- Model selection capability
- Serverless backend using AWS Lambda and API Gateway
- Frontend deployed on S3/CloudFront

## Architecture

![Architecture Diagram](architecture.png)

## Prerequisites

- AWS Account with Bedrock access
- AWS CLI configured with appropriate permissions
- Node.js (v14+)
- Python (v3.9+)
- Terraform (optional, for infrastructure deployment)

## Quick Start

1. Clone this repository
2. Run the setup script:
./scripts/setup-local-dev.sh

## Development

See [development.md](docs/development.md) for detailed information about local development workflow.

## Deployment

The application can be deployed to AWS using either:

- Terraform: `cd infrastructure/terraform && terraform apply`
- Deployment script: `./scripts/deploy.sh [environment]`

## Project Structure

- `/frontend`: React application for the user interface
- `/backend`: Python Lambda functions for the backend API
- `/infrastructure`: IaC templates for AWS resources
- `/scripts`: Utility scripts for development and deployment
- `/docs`: Additional documentation

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.