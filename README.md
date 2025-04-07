# DevOps Sandbox

A simple application demonstrating DevOps practices with Python, Docker, and GCP.

## Setup

1. Install dependencies: `make setup`
2. Run tests: `make test`
3. Run locally: `make run`

## Deployment

- Build and deploy to GCP: `make deploy`
- Infrastructure managed with Terraform in the `terraform/` directory

## Configuration

Copy `terraform/terraform.tfvars.example` to `terraform/terraform.tfvars` and update values.