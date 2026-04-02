# GCP Monitoring Template

A Terraform orchestrator module that simplifies GCP monitoring infrastructure deployment by composing official Terraform Registry modules for Pub/Sub, Cloud Functions, log-based metrics, and alert policies.

## Features

- Orchestrates 4 Terraform Registry modules (v1.0.0) for complete monitoring setup
- Feature flags to enable/disable individual components
- Automatic dependency management between modules
- Pre-configured alert policies for Cloud Run and Cloud SQL
- Cloud Function deployment with Pub/Sub triggers
- Log-based metrics with customizable filters and labels
- Pub/Sub topic with GCP Monitoring notification channel integration

---

## Architecture

This template orchestrates the following components:

```
┌─────────────────────────────────────────────────────────────┐
│                  GCP Monitoring Template                     │
│                      (Orchestrator)                          │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Pub/Sub    │  │ Cloud        │  │ Log          │      │
│  │   Topic      │──│ Function     │  │ Metrics      │      │
│  │   v1.0.0     │  │ v1.0.0       │  │ v1.0.0       │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│         │                                     │              │
│         └─────────────────┬───────────────────┘              │
│                           │                                  │
│                  ┌──────────────┐                            │
│                  │ Alert        │                            │
│                  │ Policies     │                            │
│                  │ v1.0.0       │                            │
│                  └──────────────┘                            │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

---

## Assumptions

The project assumes the following:

- A basic understanding of [Git](https://git-scm.com/)
- Git version `>= 2.33.0`
- An existing GCP IAM user or role with access to create/update/delete monitoring resources
- [GCloud CLI](https://cloud.google.com/sdk/docs/install) `>= 465.0.0`
- A basic understanding of [Terraform](https://www.terraform.io/)
- Terraform version `>= 1.3.0`
- (Optional - for local testing) A basic understanding of [Make](https://www.gnu.org/software/make/manual/make.html#Introduction)
  - Make version `>= GNU Make 3.81`
  - **Important Note**: This project includes a [Makefile](https://github.com/nurdsoft/terraform-google-monitoring/blob/main/Makefile) to speed up local development in Terraform. The `make` targets act as a wrapper around Terraform commands. As such, `make` has only been tested/verified on **Linux/Mac OS**. Though, it is possible to [install make using Chocolatey](https://community.chocolatey.org/packages/make), we **do not** guarantee this approach as it has not been tested/verified. You may use the commands in the [Makefile](https://github.com/nurdsoft/terraform-google-monitoring/blob/main/Makefile) as a guide to run each Terraform command locally on Windows.

---

## Test

**Important Note**: This project includes a [Makefile](https://github.com/nurdsoft/terraform-google-monitoring/blob/main/Makefile) to speed up local development in Terraform. The `make` targets act as a wrapper around Terraform commands. As such, `make` has only been tested/verified on **Linux/Mac OS**. Though, it is possible to [install make using Chocolatey](https://community.chocolatey.org/packages/make), we **do not** guarantee this approach as it has not been tested/verified. You may use the commands in the [Makefile](https://github.com/nurdsoft/terraform-google-monitoring/blob/main/Makefile) as a guide to run each Terraform command locally on Windows.

```sh
gcloud init # https://cloud.google.com/docs/authentication/gcloud
gcloud auth application-default login

# Copy the example tfvars and customize it
cp examples/complete/examples.tfvars examples/complete/terraform.tfvars
# Edit terraform.tfvars with your values

# Run terraform commands
make plan SVC=complete
make apply SVC=complete
make destroy SVC=complete
```

---

## Contributions

Contributions are always welcome. As such, this project uses the `main` branch as the source of truth to track changes.

**Step 1**. Clone this project.

```sh
# Using SSH
$ git clone git@github.com:nurdsoft/terraform-google-monitoring.git

# Using HTTPS
$ git clone https://github.com/nurdsoft/terraform-google-monitoring.git
```

**Step 2**. Checkout a feature branch: `git checkout -b feature/abc`.

**Step 3**. Validate the change/s locally by executing the steps defined under [Test](#test).

**Step 4**. If testing is successful, commit and push the new change/s to the remote.

```sh
$ git add file1 file2 ...
$ git commit -m "Adding some change"
$ git push --set-upstream origin feature/abc
```

**Step 5**. Once pushed, create a [PR](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) and assign it to a member for review.

- **Important Note**: It can be helpful to attach the `terraform plan` output in the PR.

**Step 6**. A team member reviews/approves/merges the change/s.

**Step 7**. Once merged, deploy the required changes as needed.

**Step 8**. Once deployed, verify that the changes have been deployed.

---

## Usage

### Basic Usage

```hcl
module "monitoring" {
  source = "git::https://github.com/nurdsoft/terraform-google-monitoring.git?ref=main"

  # Enable all modules
  enable_pubsub         = true
  enable_cloud_function = true
  enable_log_metric     = true
  enable_alert_policies = true

  # Pub/Sub configuration
  project_id                        = "my-project"
  topic_name                        = "monitoring-alerts"
  notification_channel_display_name = "Monitoring Alerts Channel"

  # Cloud Function configuration
  region               = "us-central1"
  function_name        = "alert-processor"
  function_source_dir  = "./alert-function"
  function_entry_point = "ProcessAlert"
  environment_variables = {
    SLACK_WEBHOOK_URL = var.slack_webhook_url
  }

  # Log Metric configuration
  metric_name   = "error_count"
  metric_filter = "resource.type=\"cloud_run_revision\" AND severity>=ERROR"
  metric_labels = [
    {
      key         = "service_name"
      value_type  = "STRING"
      description = "Service name"
    }
  ]
  metric_label_extractors = {
    service_name = "EXTRACT(resource.labels.service_name)"
  }
  wait_for_metric = true

  # Alert Policies configuration
  notification_channels    = [module.monitoring.notification_channel_name]
  alert_services_regex     = "my-service-.*"
}
```

### Selective Component Usage

You can enable only the components you need:

```hcl
# Only Pub/Sub and Alert Policies
module "monitoring" {
  source = "git::https://github.com/nurdsoft/terraform-google-monitoring.git?ref=main"

  enable_pubsub         = true
  enable_alert_policies = true
  enable_cloud_function = false
  enable_log_metric     = false

  project_id            = "my-project"
  notification_channels = ["projects/my-project/notificationChannels/12345"]
  alert_services_regex  = ".*"
}
```

---

## Components

### 1. Pub/Sub Topic (`nurdsoft/pubsub-topic/google`)
Creates a Pub/Sub topic for monitoring alerts with:
- GCP Monitoring notification channel
- IAM binding for Monitoring service account
- Configurable message retention

### 2. Cloud Function (`nurdsoft/cloud-function/google`)
Deploys a Cloud Function Gen 2 with:
- Automatic source code zipping and upload
- Pub/Sub trigger integration
- Configurable runtime, memory, and scaling
- Environment variable support

### 3. Log Metrics (`nurdsoft/log-metrics/google`)
Creates log-based metrics with:
- Custom log filters
- Metric labels and extractors
- Support for DELTA, GAUGE, CUMULATIVE metrics
- Built-in wait functionality for dependent resources

### 4. Alert Policies (`nurdsoft/alert-policies/google`)
Provisions 4 pre-configured alert policies:
- Cloud Run High Request Rate (>10 req/s for 60s)
- Cloud Run Error Log Spike (>1 error)
- Cloud SQL High CPU Utilization (>75%)
- Cloud SQL High Disk Utilization (>50%)

---

## Examples

| Example | Description |
|---|---|
| [complete](./examples/complete) | Full monitoring setup with all components enabled |

---

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.3 |
| google | >= 5.0 |

---

## Providers

| Name | Version |
|---|---|
| [google](https://registry.terraform.io/providers/hashicorp/google/latest) | >= 5.0 |

---

## Modules

| Name | Source | Version |
|---|---|---|
| pubsub | nurdsoft/pubsub-topic/google | 1.0.0 |
| cloud_function | nurdsoft/cloud-function/google | 1.0.0 |
| log_metric | nurdsoft/log-metrics/google | 1.0.0 |
| alert_policies | nurdsoft/alert-policies/google | 1.0.0 |

---

## Inputs

### Feature Flags

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| `enable_pubsub` | Enable Pub/Sub topic and notification channel | `bool` | `false` | no |
| `enable_cloud_function` | Enable Cloud Function deployment | `bool` | `false` | no |
| `enable_log_metric` | Enable log-based metric | `bool` | `false` | no |
| `enable_alert_policies` | Enable alert policies | `bool` | `true` | no |

### Pub/Sub Configuration

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| `project_id` | GCP project ID | `string` | `null` | yes (when pubsub enabled) |
| `topic_name` | Pub/Sub topic name | `string` | `"monitoring-alerts"` | no |
| `message_retention_duration` | Message retention duration | `string` | `"86400s"` | no |
| `notification_channel_display_name` | Notification channel display name | `string` | `"Monitoring Alerts Pub/Sub Channel"` | no |

### Cloud Function Configuration

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| `region` | GCP region | `string` | `null` | yes (when function enabled) |
| `function_name` | Function name | `string` | `"pubsub-triggered-function"` | no |
| `function_source_dir` | Function source directory | `string` | `null` | yes (when function enabled) |
| `function_runtime` | Function runtime | `string` | `"go125"` | no |
| `function_entry_point` | Function entry point | `string` | `null` | yes (when function enabled) |
| `max_instance_count` | Max function instances | `number` | `3` | no |
| `available_memory` | Function memory | `string` | `"512Mi"` | no |
| `timeout_seconds` | Function timeout | `number` | `60` | no |
| `environment_variables` | Environment variables | `map(string)` | `{}` | no |

### Log Metric Configuration

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| `metric_name` | Metric name | `string` | `null` | yes (when metric enabled) |
| `metric_filter` | Log filter | `string` | `null` | yes (when metric enabled) |
| `metric_kind` | Metric kind (DELTA/GAUGE/CUMULATIVE) | `string` | `"DELTA"` | no |
| `metric_value_type` | Value type (INT64/DOUBLE/etc) | `string` | `"INT64"` | no |
| `metric_labels` | Metric labels | `list(object)` | `[]` | no |
| `metric_label_extractors` | Label extractors | `map(string)` | `{}` | no |
| `wait_for_metric` | Wait after metric creation | `bool` | `false` | no |
| `wait_duration` | Wait duration | `string` | `"60s"` | no |

### Alert Policies Configuration

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| `notification_channels` | Notification channel IDs | `list(string)` | `[]` | no |
| `alert_services_regex` | Services regex pattern | `string` | `""` | no |
| `high_request_threshold` | Request rate threshold (req/s) | `number` | `10` | no |
| `error_threshold` | Error count threshold | `number` | `1` | no |
| `cpu_threshold` | CPU threshold (0.0-1.0) | `number` | `0.75` | no |
| `disk_threshold` | Disk threshold (0.0-1.0) | `number` | `0.50` | no |

For complete input documentation, see [variables.tf](./variables.tf).

---

## Outputs

| Name | Description |
|---|---|
| `topic_id` | Pub/Sub topic ID |
| `topic_name` | Pub/Sub topic name |
| `notification_channel_id` | Notification channel ID |
| `notification_channel_name` | Notification channel name |
| `function_id` | Cloud Function ID |
| `function_url` | Cloud Function URL |
| `metric_id` | Log metric ID |
| `metric_name` | Log metric name |
| `alert_policy_ids` | Map of alert policy IDs |
| `alert_policy_names` | Map of alert policy names |

---

## Authors

Module is maintained by [Nurdsoft](https://github.com/nurdsoft).

---

## License

Apache 2 Licensed. See LICENSE for full details.
