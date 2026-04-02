# Complete example demonstrating all monitoring components

module "monitoring" {
  source = "../.."

  # Enable all modules
  enable_pubsub         = true
  enable_cloud_function = true
  enable_log_metric     = true
  enable_alert_policies = true

  # Pub/Sub configuration
  project_id                        = var.project_id
  topic_name                        = var.topic_name
  message_retention_duration        = var.message_retention_duration
  notification_channel_display_name = var.notification_channel_display_name

  # Cloud Function configuration
  region               = var.region
  function_name        = var.function_name
  function_description = var.function_description
  function_source_dir  = "${path.module}/sample-function"
  function_runtime     = var.function_runtime
  function_entry_point = var.function_entry_point
  function_bucket_name = var.function_bucket_name
  max_instance_count   = var.max_instance_count
  available_memory     = var.available_memory
  timeout_seconds      = var.timeout_seconds
  environment_variables = var.environment_variables

  # Log Metric configuration
  metric_name            = var.metric_name
  metric_bucket_name     = var.metric_bucket_name
  metric_filter          = var.metric_filter
  metric_kind            = var.metric_kind
  metric_value_type      = var.metric_value_type
  metric_labels          = var.metric_labels
  metric_label_extractors = var.metric_label_extractors
  wait_for_metric        = var.wait_for_metric
  wait_duration          = var.wait_duration

  # Alert Policies configuration
  notification_channels           = [module.monitoring.notification_channel_name]
  alert_services_regex            = var.alert_services_regex
  high_request_alert_display_name = var.high_request_alert_display_name
  error_alert_display_name        = var.error_alert_display_name
  cpu_alert_display_name          = var.cpu_alert_display_name
  disk_alert_display_name         = var.disk_alert_display_name
}
