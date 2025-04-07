variable "alert_name" {
  type    = string
  default = "ALERT"
}

variable "alert_timeperiod" {
  description = "he amount of time for which the rule must be breached for the rule to be considered to be Firing. Before this time has elapsed, the rule is only considered to be Pending."
  type        = string
  default     = "5m"
}

variable "data_conditions" {
  type = list(object({
    ref_id         = string
    from           = number
    to             = number
    datasource_uid = string
    model          = string
  }))
  default = null
}

variable "datasources_list" {
  type        = list(string)
  description = "list of cloudwatch datasources name for which the same alert needs to be configured"
  default     = ["CloudWatch-BE"]
}

variable "grafana_folder_name" {
  type        = string
  description = "Grafana Folder name in which alert will be created"
  default     = ""
}

variable "evaluate_condition" {
  description = "he ref_id of the query node in the data field to use as the alert condition. i.e The condition ID that will be evaluated for triggering the alert. ex: C"
  type        = string
  default     = "C"
}

variable "evaluation_interval_seconds" {
  description = "The interval, in seconds, at which all rules in the group are evaluated. If a group contains many rules, the rules are evaluated sequentially."
  type        = number
  default     = "300"
}

variable "no_data_state" {
  description = "State to be set when no data is available for the condition query."
  type        = string
  default     = "NoData" # Example default value; adjust based on your needs
}

variable "manual_edit" {
  description = "If alerts needs to be manually edited."
  type        = string
  default     = "false"
}

variable "exec_err_state" {
  description = "State to be set when there is an error in executing the condition query."
  type        = string
  default     = "Alerting" # Example default value; adjust based on your needs
}

variable "annotations" {
  description = "Annotations to add more context to the alert, represented as key-value pairs."
  type        = map(string)
  default = {
    description = "Description of the alert"
    summary     = "Summary of the alert"
  }
}

variable "labels" {
  description = "Labels to categorize the alert or notification labels to target specific channels, represented as key-value pairs."
  type        = map(string)
  default = {
    created_by = "terraform" # Example label; adjust based on your needs
  }
}

variable "is_paused" {
  description = "Whether the alert rule should be paused (not evaluated)."
  type        = bool
  default     = false
}

variable "org_id" {
  description = "org id of the grafana in which alerts needs to be created."
  type        = string
  default     = "1"
}

variable "existing_folder" {
  description = "True if the grafana folder already exists."
  type        = bool
  default     = false
}




