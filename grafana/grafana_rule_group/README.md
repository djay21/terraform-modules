# Terraform GRAFANA Module

```markdown
# Configuring Grafana Alerts with Terraform

This document provides a comprehensive guide on using Terraform to configure Grafana alerts for CloudWatch data sources. The Terraform configuration facilitates the creation of multiple alerts across different data sources, allowing for customizable conditions, states, annotations, and labels within a specified Grafana folder.


# Configuring Grafana Alerts with Terraform

This document provides a comprehensive guide on using Terraform to configure Grafana alerts for CloudWatch data sources. The Terraform configuration facilitates the creation of multiple alerts across different data sources, allowing for customizable conditions, states, annotations, and labels within a specified Grafana folder.

## Prerequisites

Before you begin the Terraform configuration for Grafana alerts, ensure you have the following prerequisites met:

### Grafana Authentication Token

- **Grafana API Token**: You will need an API token with the necessary permissions to create dashboards and alerts in your Grafana instance. To generate a token:
  1. Log in to your Grafana dashboard.
  2. Navigate to **Configuration** > **API Keys**.
  3. Click on **Add API Key**, provide a name, select the role (e.g., Admin or Editor), and set the expiration period.
  4. Save the generated key securely, as it will be used in your Terraform configuration.

### AWS Access[ Optional: Only if you are using TF State backend: s3]

- **AWS Credentials**: To allow Terraform to create resources and retrieve metrics from CloudWatch, ensure you have configured AWS credentials with appropriate permissions. This can be done in several ways:
  1. **AWS CLI**: Run `aws configure` and follow the prompts to input your AWS Access Key ID, Secret Access Key, default region, and output format.
  2. **Environment Variables**: Set `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and optionally `AWS_DEFAULT_REGION` and `AWS_SESSION_TOKEN` environment variables.
  3. **Terraform AWS Provider Configuration**: Directly in your Terraform configuration, though not recommended for sensitive credentials.


## Git Repository

The Terraform modules and templates are available in the Git repository: [sb-aws-grafana](https://gitlab.myteksi.net/bersama/sb-terraform-modules/sb-aws-grafana/).


## Configuration Steps

### Step 1: Prepare Terraform Configuration

1. **Create `main.tf`**:
   - Location: `repo/environment/DEV/main.tf`
   - Purpose: Main configuration file for Terraform.

2. **Create `backend.tf`**:
   - Location: Same as `main.tf`.
   - Purpose: Configures the Terraform backend for state management.

#### Example Module Usage

```hcl
module "rds_backup_failed_alerts" {
  source           = "../../templates/RDS_BACKUP_ALERTS"
  alert_name       = "RDS-ALERT"
  annotations      = {
                        description = "Backups Jobs {{ $labels.BackupVaultName }} Failed"
                        summary     = "RDS Backup Jobs Failed Alert"
                      }
  evaluate_condition        = "C"
  datasources_list = ["CloudWatch-BE", "CloudWatch-TM", "CloudWatch-Infra", "CloudWatch-Data"]
  exec_err_state   = "Error"
  grafana_folder_name = "TF RDS ALERT"
  labels           = { "created_by" = "terraform" }
  is_paused        = false
  no_data_state    = "NoData"
  data_conditions  = [...]
}
```

### Step 2: Initialize and Apply Configuration

Execute the following commands within your Terraform configuration directory:

```sh
terraform init
terraform plan
terraform apply -auto-approve
```

### Step 3: Verify Configuration

After applying the Terraform configuration, verify the alert rules in the Grafana console. The number of rules created depends on the number of data sources passed in the Terraform configuration.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alert_name"></a> [alert\_name](#input\_alert\_name) | n/a | `string` | `""` | yes |
| <a name="input_org_id"></a> [org\_id](#input\_manual\_edit) | n/a | `string` | `"1"` | yes |
| <a name="input_alert_timeperiod"></a> [alert\_timeperiod](#input\_alert\_timeperiod) | n/a | `string` | `""` | no |
| <a name="input_existing_folder"></a> [existing\_folder](#input\_existing\_folder) | n/a | `boolean` | `"false"` | no |
| <a name="input_manual_edit"></a> [manual\_edit_](#input\_org\_id) | if alerts needs to be manually edited. | `string` | `"false"` | no |
| <a name="input_evaluation_interval_seconds"></a> [input\_evaluation\_interval\_seconds](#input\_evaluation\_interval\_seconds\) | n/a | `number` | `"300"` | yes |
| <a name="input_annotations"></a> [annotations](#input\_annotations) | Annotations to add more context to the alert, represented as key-value pairs. | `map(string)` | <pre>{<br>  "description": "Description of the alert",<br>  "summary": "Summary of the alert"<br>}</pre> | no |
| <a name="input_data_conditions"></a> [data\_conditions](#input\_data\_conditions) | n/a | <pre>list(object({<br>    ref_id         = string<br>    from           = number<br>    to             = number<br>    datasource_uid = string<br>    model          = string<br>  }))</pre> | `null` | no |
| <a name="input_datasources_list"></a> [datasources\_list](#input\_datasources\_list) | list of cloudwatch datasources name for which the same alert needs to be configured | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_evaluate_condition"></a> [evaluate\_condition](#input\_evaluate\_condition) | he ref\_id of the query node in the data field to use as the alert condition. i.e The condition ID that will be evaluated for triggering the alert. ex: C | `string` | `""` | no |
| <a name="input_exec_err_state"></a> [exec\_err\_state](#input\_exec\_err\_state) | State to be set when there is an error in executing the condition query. | `string` | `"Alerting"` | no |
| <a name="input_grafana_folder_name"></a> [grafana\_folder\_name](#input\_grafana\_folder\_name) | Grafana Folder name in which alert will be created | `string` | `""` | no |
| <a name="input_is_paused"></a> [is\_paused](#input\_is\_paused) | Whether the alert rule should be paused (not evaluated). | `bool` | `false` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to categorize the alert or notification labels to target specific channels, represented as key-value pairs. | `map(string)` | <pre>{<br>  "created_by": "terraform"<br>}</pre> | no |
| <a name="input_no_data_state"></a> [no\_data\_state](#input\_no\_data\_state) | State to be set when no data is available for the condition query. | `string` | `"NoData"` | no |
 
## Usage

Configure the variables according to your monitoring requirements for Grafana alerts. The `data_conditions` variable is essential for defining the monitoring criteria for each alert for different cloudwatch datasources.

For detailed configuration instructions, refer to the [official Grafana documentation](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) and Terraform documentation.
```

This README.md structure provides a clear guide for users on how to configure Grafana alerts for CloudWatch data sources using Terraform, including how to set up the necessary files, apply the configuration, and verify the setup. Adjust the document according to the specific details and requirements of your project.