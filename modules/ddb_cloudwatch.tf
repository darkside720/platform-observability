locals {
  # Load YAML file from here 
  dynamodb_table_thresholds = yamldecode(file("${path.module}/vars.yaml"))

  dynamodb_metrics = [
    {
      metric_name         = "ConsumedReadCapacityUnits"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Sum"
      alarm_description   = "Alarm when the read capacity exceeds the threshold"
      severity            = "Critical"
    },
    {
      metric_name         = "ConsumedWriteCapacityUnits"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Sum"
      alarm_description   = "Alarm when the write capacity exceeds the threshold"
      severity            = "Critical"
    },
    {
      metric_name         = "ThrottledRequests"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Sum"
      alarm_description   = "Alarm when the number of throttled requests exceeds the threshold"
      severity            = "Warning"
    },
    {
      metric_name         = "ReadThrottleEvents"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Sum"
      alarm_description   = "Alarm when the number of read throttle events exceeds the threshold"
      severity            = "Warning"
    },
    {
      metric_name         = "WriteThrottleEvents"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Sum"
      alarm_description   = "Alarm when the number of write throttle events exceeds the threshold"
      severity            = "Warning"
    }
  ]
/*
  # Filter DynamoDB tables based on the current environment
  filtered_dynamodb_tables = {
    for table_name, table in data.aws_dynamodb_table.all_tables : table_name => lookup(local.dynamodb_table_thresholds.dynamodb_tables, table_name, {})
    if contains(table_name, var.environment)
  }
*/
  # Create a list of all combinations of tables and metrics
  dynamodb_alarms = flatten([
    for table_name, thresholds in local.dynamodb_table_thresholds.dynamodb_tables : [
      for metric in local.dynamodb_metrics : {
        table_name           = table_name
        metric_name          = metric.metric_name
        comparison_operator  = metric.comparison_operator
        evaluation_periods   = metric.evaluation_periods
        period               = metric.period
        statistic            = metric.statistic
        threshold            = lookup(thresholds, metric.metric_name, 0)
        alarm_description    = "${metric.alarm_description} for table ${table_name}"
        severity             = metric.severity
      }
    ]
  ])
}
 
 module "dynamodb_metric_alarms" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/metric_alarm?ref=v1.1.0"

  for_each = { for alarm in local.dynamodb_alarms : "${alarm.table_name}-${alarm.metric_name}" => alarm }

  account_id  = var.account_id
  environment = var.environment
  region      = var.region
  category    = var.category
  application = var.application
  ticket      = var.ticket
  repo_url    = var.repo_url
  created_by  = var.created_by
  created_on  = var.created_on
  expiry_date = var.expiry_date

  name                = "${each.value.table_name}-${each.value.metric_name}-alarm"
  severity            = each.value.severity
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = "AWS/DynamoDB"
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold

  dimensions = {
    TableName = each.value.table_name
  }

  alarm_description = each.value.alarm_description
  alarm_actions     = [
    module.temp_sns_topic_paze_sre_alarms.arn
  ]
}

# Output the dynamodb_table_names for debugging
# output "dynamodb_table_names" {
#   value = local.dynamodb_table_names
# }