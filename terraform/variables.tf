variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region to deploy to"
  type        = string
  default     = "us-central1"
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
  default     = "python-devops-practice"
}

variable "container_image" {
  description = "Docker image to deploy"
  type        = string
}

variable "service_account_email" {
  description = "Service account email for Cloud Run"
  type        = string
  default     = null
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8080
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 10
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 0
}

variable "cpu" {
  description = "CPU allocation"
  type        = string
  default     = "1"
}

variable "memory" {
  description = "Memory allocation"
  type        = string
  default     = "512Mi"
}