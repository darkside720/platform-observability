module "sre_cloudwatch_alert" {
  for_each = var.sre_cloudwatch_alert
  source            = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/metric_alarm?ref=v1.1.0"
  account_id        = var.account_id
  environment       = var.environment
  region            = var.region
  category          = var.category
  application       = var.application
  ticket            = var.ticket
  repo_url          = var.repo_url
  created_by        = var.created_by
  created_on        = var.created_on
  expiry_date       = var.expiry_date

  name                = each.value.name
  alarm_description   = each.value.alarm_description
  severity            = each.value.severity
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  unit                = each.value.unit
  dimensions          = each.value.dimensions
  alarm_actions       = [ module.temp_sns_topic_sre_sre_alarms.arn ]
}