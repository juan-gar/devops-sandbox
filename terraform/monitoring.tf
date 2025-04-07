# Cloud Run monitoring and alerting resources

# Uptime check
resource "google_monitoring_uptime_check_config" "cloud_run_uptime" {
  display_name = "${var.service_name}-uptime-check"
  timeout      = "10s"
  period       = "60s"

  http_check {
    path           = "/health"
    port           = "443"
    use_ssl        = true
    validate_ssl   = true
    request_method = "GET"
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      host = replace(google_cloud_run_service.app.status[0].url, "https://", "")
    }
  }

  depends_on = [
    google_cloud_run_service.app
  ]
}

# Alert policy for uptime
resource "google_monitoring_alert_policy" "uptime_alert" {
  display_name = "${var.service_name}-uptime-alert"
  combiner     = "OR"
  
  conditions {
    display_name = "Uptime check failed"
    
    condition_threshold {
      filter          = "resource.type = \"uptime_url\" AND metric.type = \"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.label.\"host\"=\"${replace(google_cloud_run_service.app.status[0].url, "https://", "")}\""
      duration        = "300s"
      comparison      = "COMPARISON_LT"
      threshold_value = 1
      
      aggregations {
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = []
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = [
    # Replace with your notification channel resource name
    # "projects/${var.project_id}/notificationChannels/${var.notification_channel_id}"
  ]

  depends_on = [
    google_monitoring_uptime_check_config.cloud_run_uptime
  ]
}

# CPU utilization alert
resource "google_monitoring_alert_policy" "cpu_utilization_alert" {
  display_name = "${var.service_name}-cpu-utilization-alert"
  combiner     = "OR"
  
  conditions {
    display_name = "CPU Utilization high"
    
    condition_threshold {
      filter          = "resource.type = \"cloud_run_revision\" AND resource.label.\"service_name\"=\"${var.service_name}\" AND metric.type = \"run.googleapis.com/container/cpu/utilization\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.8 # 80% CPU utilization
      
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_PERCENTILE_99"
      }

      trigger {
        count = 1
      }
    }
  }

  # Replace with your notification channel resource name
  # notification_channels = [
  #   "projects/${var.project_id}/notificationChannels/${var.notification_channel_id}"
  # ]

  depends_on = [
    google_cloud_run_service.app
  ]
}