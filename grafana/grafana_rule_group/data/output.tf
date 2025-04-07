output "datasource_id" {
  value = [{ for d in data.grafana_data_source.ds : d.name => d.uid }]
}