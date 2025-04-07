module "ec2_backup_failure_alerts" {
  source = "../"

  alert_name = "EC2-Backup-failure-ALERT"

  annotations = {
    description = "Ec2 Backups Jobs {{ $labels.BackupVaultName }} failed"
    summary     = "EC2 Backup Jobs failure Alert"
  }

  alert_timeperiod            = "0"
  evaluate_condition          = "C"
  evaluation_interval_seconds = 86400

  datasources_list = [
    "CloudWatch-BE",
  ]
  exec_err_state      = "Error"
  grafana_folder_name = "TF TESTING ALERT"
  existing_folder = true

  labels = {
    "created_by" = "terraform"
  }
  is_paused     = false
  no_data_state = "NoData"
  org_id        = 1

  data_conditions = [
    {
      ref_id         = "A"
      from           = 300
      to             = 0
      datasource_uid = ""
      model = "{\"datasource\":{\"type\":\"cloudwatch\",\"uid\":\"datasource_id\"},\"dimensions\":{\"DLMPolicyId\":\"*\"},\"expression\":\"\",\"id\":\"\",\"intervalMs\":1000,\"label\":\"\",\"logGroupNames\":[],\"logGroups\":[],\"matchExact\":false,\"maxDataPoints\":43200,\"metricEditorMode\":0,\"metricName\":\"SnapshotsCreateCompleted\",\"metricQueryType\":0,\"namespace\":\"AWS/EBS\",\"period\":\"\",\"queryMode\":\"Metrics\",\"refId\":\"A\",\"region\":\"ap-southeast-3\",\"sqlExpression\":\"\",\"statistic\":\"Sum\"}"

      # model          = "{\"datasource\":{\"type\":\"cloudwatch\",\"uid\":\"datasource_id\"},\"dimensions\":{\"BackupVaultName\":\"*\",\"ResourceType\":\"RDS\"},\"expression\":\"\",\"id\":\"\",\"intervalMs\":1000,\"label\":\"\",\"logGroupNames\":[],\"logGroups\":[],\"matchExact\":false,\"maxDataPoints\":43200,\"metricEditorMode\":0,\"metricName\":\"NumberOfBackupJobsFailed\",\"metricQueryType\":0,\"namespace\":\"AWS/Backup\",\"period\":\"\",\"queryMode\":\"Metrics\",\"refId\":\"A\",\"region\":\"ap-southeast-3\",\"sqlExpression\":\"\",\"statistic\":\"Sum\"}"
    },
    {
      ref_id         = "B"
      from           = 300
      to             = 0
      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"B\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"A\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"reducer\":\"last\",\"refId\":\"B\",\"settings\":{\"mode\":\"replaceNN\",\"replaceWithValue\":0},\"type\":\"reduce\"}"
    },
    {
      ref_id         = "C"
      from           = 300
      to             = 0
      datasource_uid = "__expr__"
      model          = "{\"conditions\":[{\"evaluator\":{\"params\":[0],\"type\":\"gt\"},\"operator\":{\"type\":\"and\"},\"query\":{\"params\":[\"C\"]},\"reducer\":{\"params\":[],\"type\":\"last\"},\"type\":\"query\"}],\"datasource\":{\"type\":\"__expr__\",\"uid\":\"__expr__\"},\"expression\":\"B\",\"intervalMs\":1000,\"maxDataPoints\":43200,\"refId\":\"C\",\"type\":\"threshold\"}"
    }
  ]
}