variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "topic_name" {
  description = "Pub/Sub topic name"
  type        = string
  default     = "monitoring-alerts"
}

variable "message_retention_duration" {
  description = "Message retention duration"
  type        = string
  default     = "86400s"
}

variable "notification_channel_display_name" {
  description = "Notification channel display name"
  type        = string
  default     = "Monitoring Alerts Channel"
}

variable "function_name" {
  description = "Cloud Function name"
  type        = string
  default     = "alert-processor"
}

variable "function_description" {
  description = "Cloud Function description"
  type        = string
  default     = "Processes monitoring alerts from Pub/Sub"
}

variable "function_runtime" {
  description = "Cloud Function runtime"
  type        = string
  default     = "go125"
}

variable "function_entry_point" {
  description = "Cloud Function entry point"
  type        = string
  default     = "ProcessAlert"
}

variable "function_bucket_name" {
  description = "GCS bucket name for function source"
  type        = string
  default     = "monitoring-function-source"
}

variable "max_instance_count" {
  description = "Maximum function instances"
  type        = number
  default     = 3
}

variable "available_memory" {
  description = "Function memory"
  type        = string
  default     = "512Mi"
}

variable "timeout_seconds" {
  description = "Function timeout"
  type        = number
  default     = 60
}

variable "environment_variables" {
  description = "Environment variables for function"
  type        = map(string)
  default     = {}
}

variable "metric_name" {
  description = "Log-based metric name"
  type        = string
  default     = "error_count"
}

variable "metric_bucket_name" {
  description = "Log bucket name"
  type        = string
  default     = null
}

variable "metric_filter" {
  description = "Log filter for metric"
  type        = string
  default     = "resource.type=\"cloud_run_revision\" AND severity>=ERROR"
}

variable "metric_kind" {
  description = "Metric kind"
  type        = string
  default     = "DELTA"
}

variable "metric_value_type" {
  description = "Metric value type"
  type        = string
  default     = "INT64"
}

variable "metric_labels" {
  description = "Metric labels"
  type = list(object({
    key         = string
    value_type  = string
    description = string
  }))
  default = []
}

variable "metric_label_extractors" {
  description = "Label extractors"
  type        = map(string)
  default     = {}
}

variable "wait_for_metric" {
  description = "Wait for metric creation"
  type        = bool
  default     = true
}

variable "wait_duration" {
  description = "Wait duration"
  type        = string
  default     = "60s"
}

variable "alert_services_regex" {
  description = "Services regex for alerts"
  type        = string
  default     = ".*"
}

variable "high_request_alert_display_name" {
  description = "High request alert name"
  type        = string
  default     = "Cloud Run - High Request Rate"
}

variable "error_alert_display_name" {
  description = "Error alert name"
  type        = string
  default     = "Cloud Run - Error Log Spike"
}

variable "cpu_alert_display_name" {
  description = "CPU alert name"
  type        = string
  default     = "Cloud SQL - High CPU"
}

variable "disk_alert_display_name" {
  description = "Disk alert name"
  type        = string
  default     = "Cloud SQL - High Disk"
}
