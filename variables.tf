# ------------------------------------------------------------------------------
# Feature Flags
# ------------------------------------------------------------------------------

variable "enable_pubsub" {
  description = "Set to true to deploy the Pub/Sub topic and GCP Monitoring notification channel."
  type        = bool
  default     = false
}

variable "enable_alert_policies" {
  description = "Set to true to deploy GCP Monitoring alert policies."
  type        = bool
  default     = true
}

variable "enable_cloud_function" {
  description = "Set to true to deploy the Cloud Function Gen 2."
  type        = bool
  default     = false
}

variable "enable_log_metric" {
  description = "Set to true to deploy the log-based metric."
  type        = bool
  default     = false
}

# ------------------------------------------------------------------------------
# Pub/Sub
# ------------------------------------------------------------------------------

variable "project_id" {
  description = "The GCP project ID. Required when enable_pubsub is true."
  type        = string
  default     = null
}

variable "topic_name" {
  description = "The name of the Pub/Sub topic that receives GCP Monitoring alert notifications."
  type        = string
  default     = "monitoring-alerts"
}

variable "message_retention_duration" {
  description = "How long to retain unacknowledged messages in the topic (e.g. \"86400s\" for 1 day)."
  type        = string
  default     = "86400s"
}

variable "notification_channel_display_name" {
  description = "Display name for the GCP Monitoring notification channel that publishes alerts to the Pub/Sub topic."
  type        = string
  default     = "Monitoring Alerts Pub/Sub Channel"
}

variable "monitoring_publisher_role" {
  description = "The IAM role granted to the GCP Monitoring service account to allow it to publish alert messages to the Pub/Sub topic."
  type        = string
  default     = "roles/pubsub.publisher"
}

# ------------------------------------------------------------------------------
# Alert Policies – Shared
# ------------------------------------------------------------------------------

variable "notification_channels" {
  description = <<-EOT
    Identifies the notification channels to which notifications should be sent when incidents are opened or closed or when new violations occur on an already opened incident. Each element of this array corresponds to the name field in each of the NotificationChannel objects that are returned from the notificationChannels.list method. The syntax of the entries in this field is projects/[PROJECT_ID]/notificationChannels/[CHANNEL_ID]
  EOT
  type        = list(string)
  default     = []
}

variable "alert_services_regex" {
  description = "Regex pattern used to match Cloud Run service names for request-rate and error-log alerts (e.g. \"service-a|service-b\")."
  type        = string
  default     = ""
}

# ------------------------------------------------------------------------------
# Alert Policy 1 – Cloud Run High Request Rate
# ------------------------------------------------------------------------------

variable "high_request_alert_display_name" {
  description = "Display name for the Cloud Run high request rate alert policy."
  type        = string
  default     = "Cloud Run - High Request Rate Alert"
}

variable "high_request_threshold" {
  description = "Request rate threshold in requests per second. Alert fires when this value is exceeded."
  type        = number
  default     = 10
}

variable "high_request_duration" {
  description = "Duration the request rate must remain above the threshold before the alert fires (e.g. \"60s\")."
  type        = string
  default     = "60s"
}

# ------------------------------------------------------------------------------
# Alert Policy 2 – Cloud Run Error Logs
# ------------------------------------------------------------------------------

variable "error_alert_display_name" {
  description = "Display name for the Cloud Run error log spike alert policy."
  type        = string
  default     = "Cloud Run - Error Log Spike Alert"
}

variable "error_threshold" {
  description = "Number of ERROR log entries that must be exceeded before the alert fires."
  type        = number
  default     = 1
}

variable "error_duration" {
  description = "Duration the error count must remain above the threshold before the alert fires (e.g. \"0s\")."
  type        = string
  default     = "0s"
}

# ------------------------------------------------------------------------------
# Alert Policy 3 – Cloud SQL CPU Utilization
# ------------------------------------------------------------------------------

variable "cpu_alert_display_name" {
  description = "Display name for the Cloud SQL CPU utilization alert policy."
  type        = string
  default     = "Cloud SQL - High CPU Utilization Alert"
}

variable "cpu_threshold" {
  description = "CPU utilization threshold as a decimal fraction (0.0–1.0). Default is 0.75 (75%)."
  type        = number
  default     = 0.75
}

variable "cpu_duration" {
  description = "Duration the CPU utilization must remain above the threshold before the alert fires (e.g. \"0s\")."
  type        = string
  default     = "0s"
}

# ------------------------------------------------------------------------------
# Alert Policy 4 – Cloud SQL Disk Utilization
# ------------------------------------------------------------------------------

variable "disk_alert_display_name" {
  description = "Display name for the Cloud SQL disk utilization alert policy."
  type        = string
  default     = "Cloud SQL - High Disk Utilization Alert"
}

variable "disk_threshold" {
  description = "Disk utilization threshold as a decimal fraction (0.0–1.0). Default is 0.50 (50%)."
  type        = number
  default     = 0.50
}

variable "disk_duration" {
  description = "Duration the disk utilization must remain above the threshold before the alert fires (e.g. \"0s\")."
  type        = string
  default     = "0s"
}

# ------------------------------------------------------------------------------
# Cloud Function Gen 2
# ------------------------------------------------------------------------------

variable "region" {
  description = "The GCP region to deploy the Cloud Function and Storage Bucket. Required when enable_cloud_function is true."
  type        = string
  default     = null
}

variable "function_name" {
  description = "The name of the Cloud Function."
  type        = string
  default     = "pubsub-triggered-function"
}

variable "function_description" {
  description = "The description of the Cloud Function."
  type        = string
  default     = "Cloud Function triggered by Pub/Sub messages"
}

variable "function_source_dir" {
  description = "The local directory path containing the Cloud Function source code. Required when enable_cloud_function is true."
  type        = string
  default     = null
}

variable "function_runtime" {
  description = "The runtime environment for the Cloud Function (e.g. go125, python311, nodejs20)."
  type        = string
  default     = "go125"
}

variable "function_entry_point" {
  description = "The name of the function to execute when the Cloud Function is triggered. Required when enable_cloud_function is true."
  type        = string
  default     = null
}

variable "pubsub_topic_id" {
  description = "The fully-qualified Pub/Sub topic ID that triggers the Cloud Function. Required when enable_cloud_function is true."
  type        = string
  default     = null
}

variable "function_bucket_name" {
  description = "The base name of the GCS bucket used to store the function source code."
  type        = string
  default     = "cloud-function-source"
}

variable "bucket_lifecycle_age_days" {
  description = "Number of days after which old function archives are automatically deleted."
  type        = number
  default     = 30
}

variable "max_instance_count" {
  description = "The maximum number of function instances that can run simultaneously."
  type        = number
  default     = 3
}

variable "available_memory" {
  description = "The amount of memory available for the function (e.g. 256Mi, 512Mi, 1Gi)."
  type        = string
  default     = "512Mi"
}

variable "timeout_seconds" {
  description = "The maximum amount of time the function can run before timing out (in seconds)."
  type        = number
  default     = 60
}

variable "environment_variables" {
  description = "A map of environment variables to pass to the Cloud Function."
  type        = map(string)
  default     = {}
}

variable "event_trigger_type" {
  description = "The type of event that triggers the function."
  type        = string
  default     = "google.cloud.pubsub.topic.v1.messagePublished"
}

variable "retry_policy" {
  description = "The retry policy for failed function executions."
  type        = string
  default     = "RETRY_POLICY_DO_NOT_RETRY"
}

# ------------------------------------------------------------------------------
# Log Metric
# ------------------------------------------------------------------------------

variable "metric_name" {
  description = "The name of the log-based metric. Required when enable_log_metric is true."
  type        = string
  default     = null
}

variable "metric_filter" {
  description = "The filter to apply when extracting logs for the metric. Required when enable_log_metric is true."
  type        = string
  default     = null
}

variable "metric_bucket_name" {
  description = "The log bucket name. If not provided, uses the default _Default bucket."
  type        = string
  default     = null
}

variable "metric_description" {
  description = "A description of the log-based metric."
  type        = string
  default     = null
}

variable "metric_kind" {
  description = "The kind of measurement (DELTA, GAUGE, or CUMULATIVE)."
  type        = string
  default     = "DELTA"
}

variable "metric_value_type" {
  description = "The type of data (INT64, DOUBLE, BOOL, STRING, or DISTRIBUTION)."
  type        = string
  default     = "INT64"
}

variable "metric_unit" {
  description = "The unit of measurement."
  type        = string
  default     = null
}

variable "metric_display_name" {
  description = "The display name for the metric descriptor."
  type        = string
  default     = null
}

variable "metric_labels" {
  description = "List of labels for the metric descriptor."
  type = list(object({
    key         = string
    value_type  = string
    description = string
  }))
  default = []
}

variable "metric_label_extractors" {
  description = "Map of label keys to extraction expressions."
  type        = map(string)
  default     = {}
}

variable "metric_bucket_options" {
  description = "Bucket options for DISTRIBUTION metrics."
  type = object({
    linear_buckets = optional(object({
      num_finite_buckets = number
      width              = number
      offset             = number
    }))
    exponential_buckets = optional(object({
      num_finite_buckets = number
      growth_factor      = number
      scale              = number
    }))
    explicit_buckets = optional(object({
      bounds = list(number)
    }))
  })
  default = null
}

variable "wait_for_metric" {
  description = "Whether to wait after creating the metric before proceeding (useful when creating alert policies that depend on this metric)."
  type        = bool
  default     = false
}

variable "wait_duration" {
  description = "How long to wait after creating the metric (e.g. '60s')."
  type        = string
  default     = "60s"
}
