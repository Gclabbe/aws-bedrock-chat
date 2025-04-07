#!/bin/bash
# Script to set up local development environment

set -e

PROJECT_ROOT=$(pwd)

# Install backend dependencies
echo "Setting up backend environment..."
cd $PROJECT_ROOT/backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pip install -r requirements-dev.txt
deactivate

# Install frontend dependencies
echo "Setting up frontend environment..."
cd $PROJECT_ROOT/frontend
npm install

# Set up local environment variables
echo "Setting up environment variables..."
echo "REACT_APP_API_ENDPOINT=http://localhost:3001/chat" > .env.development

echo "Local development environment setup complete!"
echo ""
echo "To start backend locally (uses AWS credentials):"
echo "cd backend && source venv/bin/activate && python -m src.local"
echo ""
echo "To start frontend locally:"
echo "cd frontend && npm start"
