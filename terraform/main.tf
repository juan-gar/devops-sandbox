terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  
  backend "gcs" {
    bucket = "YOUR_TERRAFORM_STATE_BUCKET"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Enable required services
resource "google_project_service" "services" {
  for_each = toset([
    "run.googleapis.com",
    "iam.googleapis.com",
    "artifactregistry.googleapis.com"
  ])
  
  project = var.project_id
  service = each.key

  disable_on_destroy = false
}

# Cloud Run service
resource "google_cloud_run_service" "app" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      service_account_name = var.service_account_email
      containers {
        image = var.container_image

        ports {
          container_port = var.container_port
        }
        
        resources {
          limits = {
            cpu    = var.cpu
            memory = var.memory
          }
        }
      }
    }
    
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = var.min_instances
        "autoscaling.knative.dev/maxScale" = var.max_instances
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [
    google_project_service.services
  ]
}

# IAM policy to make the service public
resource "google_cloud_run_service_iam_member" "public_access" {
  location = google_cloud_run_service.app.location
  project  = var.project_id
  service  = google_cloud_run_service.app.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Output the service URL
output "service_url" {
  value = google_cloud_run_service.app.status[0].url
}