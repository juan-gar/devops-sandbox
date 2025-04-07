.PHONY: install test lint build-docker run-docker terraform-init terraform-plan terraform-apply help

# Application variables
APP_NAME := python-devops-practice
DOCKER_USERNAME := YOUR_DOCKERHUB_USERNAME
DOCKER_IMAGE := $(DOCKER_USERNAME)/$(APP_NAME)
GCP_PROJECT_ID := YOUR_GCP_PROJECT_ID
GCP_REGION := us-central1

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies
	pip install -r requirements.txt

test: ## Run tests
	pytest -xvs src/

test-coverage: ## Run tests with coverage
	pytest --cov=src src/ --cov-report=term-missing

lint: ## Run linting
	flake8 src/

clean: ## Clean up Python cache files
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -rf .pytest_cache .coverage htmlcov

run: ## Run the application locally
	python -m src.app

build-docker: ## Build Docker image
	docker build -t $(DOCKER_IMAGE):latest .

run-docker: ## Run Docker container locally
	docker run -p 8080:8080 $(DOCKER_IMAGE):latest

push-docker: ## Push Docker image to registry
	docker push $(DOCKER_IMAGE):latest

terraform-init: ## Initialize Terraform
	cd terraform && terraform init

terraform-plan: ## Preview Terraform changes
	cd terraform && terraform plan -var="project_id=$(GCP_PROJECT_ID)" -var="container_image=$(DOCKER_IMAGE):latest"

terraform-apply: ## Apply Terraform changes
	cd terraform && terraform apply -var="project_id=$(GCP_PROJECT_ID)" -var="container_image=$(DOCKER_IMAGE):latest"

deploy-cloud-run: ## Deploy to Cloud Run manually
	gcloud run deploy $(APP_NAME) \
		--image $(DOCKER_IMAGE):latest \
		--platform managed \
		--region $(GCP_REGION) \
		--project $(GCP_PROJECT_ID) \
		--allow-unauthenticated