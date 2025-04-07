variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region where resources will be created"
  type        = string
  default     = "us-central1"
}

variable "container_image" {
  description = "The container image to deploy"
  type        = string
}

variable "latency_threshold" {
  description = "Threshold in milliseconds for latency alerts"
  type        = number
  default     = 500
}

variable "notification_channels" {
  description = "List of notification channel IDs"
  type        = list(string)
  default     = []
}
