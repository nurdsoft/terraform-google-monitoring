output "topic_id" {
  description = "Pub/Sub topic ID"
  value       = module.monitoring.topic_id
}

output "notification_channel_name" {
  description = "Notification channel name"
  value       = module.monitoring.notification_channel_name
}

output "function_url" {
  description = "Cloud Function URL"
  value       = module.monitoring.function_url
}

output "metric_id" {
  description = "Log metric ID"
  value       = module.monitoring.metric_id
}

output "alert_policy_ids" {
  description = "Alert policy IDs"
  value       = module.monitoring.alert_policy_ids
}
