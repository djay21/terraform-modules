data "grafana_data_source" "ds" {
  count = length(var.datasources_list)
  name  = var.datasources_list[count.index]
}