
locals {
  abcd = module.datasource.datasource_id
  rules = [for datasource in var.datasources_list : {
    name             = "${datasource}-${var.alert_name}"
    index            = "${datasource}"
    alert_timeperiod = var.alert_timeperiod
    condition        = var.evaluate_condition
    no_data_state    = var.no_data_state
    exec_err_state   = var.exec_err_state
    annotations      = var.annotations
    labels           = var.labels
    is_paused        = var.is_paused
    data_conditions  = var.data_conditions
  }]
}

module "datasource" {
  source = "./data"

  datasources_list = var.datasources_list

}