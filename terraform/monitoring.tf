resource "google_monitoring_alert_policy" "app_latency" {
  display_name = "Cloud Run Latency Alert"
  combiner     = "OR"

  conditions {
    display_name = "High latency"
    
    condition_threshold {
      filter          = "resource.type = 'cloud_run_revision' AND resource.labels.service_name = 'devops-app' AND metric.type = 'run.googleapis.com/request_latencies'"
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.latency_threshold
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_PERCENTILE_99"
      }
    }
  }

  notification_channels = var.notification_channels
}

resource "google_monitoring_dashboard" "app_dashboard" {
  dashboard_json = <<EOF
{
  "displayName": "DevOps App Dashboard",
  "gridLayout": {
    "widgets": [
      {
        "title": "Request Latency",
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "resource.type = 'cloud_run_revision' AND resource.labels.service_name = 'devops-app' AND metric.type = 'run.googleapis.com/request_latencies'",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_PERCENTILE_99"
                  }
                }
              }
            }
          ]
        }
      },
      {
        "title": "Request Count",
        "xyChart": {
          "dataSets": [
            {
              "timeSeriesQuery": {
                "timeSeriesFilter": {
                  "filter": "resource.type = 'cloud_run_revision' AND resource.labels.service_name = 'devops-app' AND metric.type = 'run.googleapis.com/request_count'",
                  "aggregation": {
                    "alignmentPeriod": "60s",
                    "perSeriesAligner": "ALIGN_RATE"
                  }
                }
              }
            }
          ]
        }
      }
    ]
  }
}
EOF
}
