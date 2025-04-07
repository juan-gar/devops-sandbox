# GCP Cloud Run Deployment with GitHub Actions and Terraform

This repository contains a sample Python Flask application with complete CI/CD pipelines for deploying to Google Cloud Run using GitHub Actions and Terraform.

## Project Structure

```
.
├── github-actions        # GitHub Actions workflow definitions
├── src                   # Python application source code
├── terraform             # Terraform configuration
├── Dockerfile            # Docker container definition
├── Makefile              # Automation tasks
├── requirements.txt      # Python dependencies
└── README.md             # This file
```

## Prerequisites

1. A Google Cloud Platform account with billing enabled
2. A GitHub account
3. Docker Hub account
4. Local development tools: Python 3.9+, pip, Docker, Terraform

## Setup Instructions

### 1. GCP Setup

1. Create a new GCP project or use an existing one
2. Enable required APIs:
   - Cloud Run API
   - IAM API
   - Artifact Registry API
   - Cloud Storage API
3. Create a service account with the following roles:
   - Cloud Run Admin
   - Storage Admin
   - Service Account User
4. Generate and download a JSON key for the service account

### 2. GitHub Repository Setup

1. Create a new repository and push this code to it
2. Add the following secrets to your GitHub repository:
   - `GCP_PROJECT_ID`: Your GCP project ID
   - `GCP_SA_KEY`: The content of the service account JSON key
   - `DOCKERHUB_USERNAME`: Your Docker Hub username
   - `DOCKERHUB_TOKEN`: Your Docker Hub access token

### 3. Terraform Setup

1. Create a GCS bucket for storing Terraform state:
   ```
   gsutil mb gs://YOUR_TERRAFORM_STATE_BUCKET
   ```
2. Update `terraform/main.tf` with your bucket name in the backend configuration
3. Create a `terraform.tfvars` file based on `terraform.tfvars.example` with your configuration

### 4. Update Application Configuration

1. Update the `APP_NAME`, `DOCKER_USERNAME`, and `GCP_PROJECT_ID` variables in the Makefile

## GitHub Actions Workflows

This repository includes the following GitHub Actions workflows:

1. **Build and Test**: Runs on every push and pull request to run linting and tests
2. **Docker Build and Push**: Builds the Docker image and pushes it to Docker Hub
3. **Create Cloud Run Service**: Creates a new Cloud Run service (manual trigger)
4. **Deploy to Cloud Run**: Deploys new revisions to the existing Cloud Run service
5. **Terraform Deploy**: Manages infrastructure using Terraform

## Local Development

1. Clone the repository
2. Create a virtual environment and install dependencies:
   ```
   python -m venv venv
   source venv/bin/activate  # On Windows, use: venv\Scripts\activate
   pip install -r requirements.txt
   ```
3. Run tests:
   ```
   pytest src/
   ```
4. Start the application locally:
   ```
   python -m src.app
   ```
5. Use the Makefile for common operations:
   ```
   make help    # Show available commands
   make lint    # Run linting
   make test    # Run tests
   make run     # Run locally
   ```

## Docker Commands

Build the Docker image:
```
make build-docker
```

Run the Docker container locally:
```
make run-docker
```

## Terraform Commands

Initialize Terraform:
```
make terraform-init
```

Plan changes:
```
make terraform-plan
```

Apply changes:
```
make terraform-apply
```

## Security Considerations

- The Cloud Run service is public by default; modify the IAM policy in `terraform/main.tf` if you need more restricted access
- Secrets are managed through GitHub Secrets
- Service account has least-privilege permissions needed for deployment

## License

MIT