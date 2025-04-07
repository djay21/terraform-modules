variable "datasources_list" {
  type        = list(string)
  description = "list of cloudwatch datasources name for which the same alert needs to be configured"
  default     = [""]
}
