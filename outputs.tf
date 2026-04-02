# Root module outputs
# Aggregates outputs from submodules

# ------------------------------------------------------------------------------
# Pub/Sub
# ------------------------------------------------------------------------------

output "topic_id" {
  description = "The fully-qualified ID of the Pub/Sub topic. Empty string if pubsub is disabled."
  value       = var.enable_pubsub ? module.pubsub[0].topic_id : ""
}

output "topic_name" {
  description = "The short name of the Pub/Sub topic. Empty string if pubsub is disabled."
  value       = var.enable_pubsub ? module.pubsub[0].topic_name : ""
}

output "notification_channel_id" {
  description = "The fully-qualified ID of the GCP Monitoring notification channel. Empty string if pubsub is disabled."
  value       = var.enable_pubsub ? module.pubsub[0].notification_channel_id : ""
}

output "notification_channel_name" {
  description = "The resource name of the GCP Monitoring notification channel. Pass this as notification_channels to the alert-policies module. Empty string if pubsub is disabled."
  value       = var.enable_pubsub ? module.pubsub[0].notification_channel_name : ""
}

# ------------------------------------------------------------------------------
# Alert Policies
# ------------------------------------------------------------------------------

output "alert_policy_ids" {
  description = "Map of alert policy keys to their GCP resource IDs. Empty map if alert policies are disabled."
  value       = var.enable_alert_policies ? module.alert_policies[0].alert_policy_ids : {}
}

output "alert_policy_names" {
  description = "Map of alert policy keys to their GCP resource names. Empty map if alert policies are disabled."
  value       = var.enable_alert_policies ? module.alert_policies[0].alert_policy_names : {}
}

# ------------------------------------------------------------------------------
# Cloud Function Gen 2
# ------------------------------------------------------------------------------

output "function_id" {
  description = "The fully-qualified ID of the Cloud Function. Empty string if cloud function is disabled."
  value       = var.enable_cloud_function ? module.cloud_function[0].function_id : ""
}

output "function_name" {
  description = "The name of the Cloud Function. Empty string if cloud function is disabled."
  value       = var.enable_cloud_function ? module.cloud_function[0].function_name : ""
}

output "function_url" {
  description = "The URL of the Cloud Function service. Empty string if cloud function is disabled."
  value       = var.enable_cloud_function ? module.cloud_function[0].function_url : ""
}

output "bucket_name" {
  description = "The name of the GCS bucket storing the function source code. Empty string if cloud function is disabled."
  value       = var.enable_cloud_function ? module.cloud_function[0].bucket_name : ""
}

output "bucket_url" {
  description = "The URL of the GCS bucket. Empty string if cloud function is disabled."
  value       = var.enable_cloud_function ? module.cloud_function[0].bucket_url : ""
}

# ------------------------------------------------------------------------------
# Log Metric
# ------------------------------------------------------------------------------

output "metric_id" {
  description = "The fully-qualified ID of the log-based metric. Empty string if log metric is disabled."
  value       = var.enable_log_metric ? module.log_metric[0].metric_id : ""
}

output "metric_name" {
  description = "The name of the log-based metric. Empty string if log metric is disabled."
  value       = var.enable_log_metric ? module.log_metric[0].metric_name : ""
}

output "metric_descriptor_type" {
  description = "The metric descriptor type. Empty string if log metric is disabled."
  value       = var.enable_log_metric ? module.log_metric[0].metric_descriptor_type : ""
}
