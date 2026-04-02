# Root module - orchestrates submodules using Terraform Registry modules
# Currently supports: alert-policies, pubsub, cloud-function, log-metric

module "pubsub" {
  source  = "nurdsoft/pubsub-topic/google"
  version = "1.0.0"
  count   = var.enable_pubsub ? 1 : 0

  project_id                        = var.project_id
  topic_name                        = var.topic_name
  message_retention_duration        = var.message_retention_duration
  notification_channel_display_name = var.notification_channel_display_name
  monitoring_publisher_role         = var.monitoring_publisher_role
}

module "alert_policies" {
  source  = "nurdsoft/alert-policies/google"
  version = "1.0.0"
  count   = var.enable_alert_policies ? 1 : 0

  notification_channels           = var.notification_channels
  alert_services_regex            = var.alert_services_regex
  high_request_alert_display_name = var.high_request_alert_display_name
  error_alert_display_name        = var.error_alert_display_name
  cpu_alert_display_name          = var.cpu_alert_display_name
  disk_alert_display_name         = var.disk_alert_display_name
  high_request_threshold          = var.high_request_threshold
  high_request_duration           = var.high_request_duration
  error_threshold                 = var.error_threshold
  error_duration                  = var.error_duration
  cpu_threshold                   = var.cpu_threshold
  cpu_duration                    = var.cpu_duration
  disk_threshold                  = var.disk_threshold
  disk_duration                   = var.disk_duration
}

module "cloud_function" {
  source  = "nurdsoft/cloud-function/google"
  version = "1.0.0"
  count   = var.enable_cloud_function ? 1 : 0

  project_id                = var.project_id
  region                    = var.region
  function_name             = var.function_name
  function_description      = var.function_description
  function_source_dir       = var.function_source_dir
  function_runtime          = var.function_runtime
  function_entry_point      = var.function_entry_point
  # Use pubsub module output if enabled, otherwise use provided variable
  pubsub_topic_id           = var.enable_pubsub ? module.pubsub[0].topic_id : var.pubsub_topic_id
  function_bucket_name      = var.function_bucket_name
  max_instance_count        = var.max_instance_count
  available_memory          = var.available_memory
  timeout_seconds           = var.timeout_seconds
  environment_variables     = var.environment_variables
  event_trigger_type        = var.event_trigger_type
  retry_policy              = var.retry_policy
  bucket_lifecycle_age_days = var.bucket_lifecycle_age_days
}

module "log_metric" {
  source  = "nurdsoft/log-metrics/google"
  version = "1.0.0"
  count   = var.enable_log_metric ? 1 : 0

  project_id       = var.project_id
  metric_name      = var.metric_name
  filter           = var.metric_filter
  bucket_name      = var.metric_bucket_name
  description      = var.metric_description
  metric_kind      = var.metric_kind
  value_type       = var.metric_value_type
  unit             = var.metric_unit
  display_name     = var.metric_display_name
  labels           = var.metric_labels
  label_extractors = var.metric_label_extractors
  bucket_options   = var.metric_bucket_options
  wait_for_metric  = var.wait_for_metric
  wait_duration    = var.wait_duration
}
