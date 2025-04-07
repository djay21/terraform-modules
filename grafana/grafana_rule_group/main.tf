resource "grafana_folder" "my_folder" {
  count = var.existing_folder ? 0 : 1
  title = var.grafana_folder_name
}

data "grafana_folder" "existing" {
  depends_on = [ grafana_folder.my_folder ]
  count = var.existing_folder ? 1 : 0
  title = var.grafana_folder_name
}


resource "grafana_rule_group" "rule_group_0000" {

  depends_on         = [module.datasource, grafana_folder.my_folder]
  org_id             = var.org_id
  disable_provenance = var.manual_edit
  name               = var.alert_name
  folder_uid         = var.existing_folder ? data.grafana_folder.existing[0].uid : element(concat(grafana_folder.my_folder.*.uid, [""]), 0)
  interval_seconds   = var.evaluation_interval_seconds

  dynamic "rule" {
    for_each = local.rules

    content {
      name           = rule.value.name
      for            = rule.value.alert_timeperiod
      condition      = rule.value.condition
      no_data_state  = rule.value.no_data_state
      exec_err_state = rule.value.exec_err_state
      annotations    = rule.value.annotations
      labels         = rule.value.labels
      is_paused      = rule.value.is_paused

      dynamic "data" {
        for_each = var.data_conditions

        content {
          ref_id = data.value.ref_id

          relative_time_range {
            from = data.value.from
            to   = data.value.to
          }

          datasource_uid = data.value.datasource_uid == "" ? lookup(local.abcd[0], rule.value.index, "") : data.value.datasource_uid
          model          = replace(data.value.model, "datasource_id", lookup(local.abcd[0], rule.value.index, ""))
        }
      }
    }
  }
}