locals {
  docker_metrics = {
    cpu_critical = {
        metric_name         = "CPU"
        comparison_operator = "GreaterThanOrEqualToThreshold"
        evaluation_periods  = 3
        period              = 300
        statistic           = "Average"
        unit                = "Percent"
        threshold           = 90
        alarm_description   = "Critical: High CPU Utilization"
        severity            = "Critical"
        namespace           = "DockerStats"
    },
    mem_critical = {
        metric_name         = "Memory"
        comparison_operator = "GreaterThanOrEqualToThreshold"
        evaluation_periods  = 3
        period              = 300
        statistic           = "Average"
        unit                = "Percent"
        threshold           = 90
        alarm_description   = "Critical: High Memory Utilization"
        severity            = "Critical"
        namespace           = "DockerStats"
    },
    cpu_warning = {
        metric_name         = "CPU"
        comparison_operator = "GreaterThanOrEqualToThreshold"
        evaluation_periods  = 3
        period              = 300
        statistic           = "Average"
        unit                = "Percent"
        threshold           = 75
        alarm_description   = "Warning: CPU Utilization Warning"
        severity            = "Warning"
        namespace           = "DockerStats"
    },
    mem_warning = {
        metric_name         = "Memory"
        comparison_operator = "GreaterThanOrEqualToThreshold"
        evaluation_periods  = 3
        period              = 300
        statistic           = "Average"
        unit                = "Percent"
        threshold           = 75
        alarm_description   = "Warning: Memory Utilization Warning"
        severity            = "Warning"
        namespace           = "DockerStats"
    },
    ports_critical = {
        metric_name         = "Ports"
        comparison_operator = "LessThanThreshold"
        evaluation_periods  = 3
        period              = 300
        statistic           = "Average"
        unit                = "Count"
        threshold           = 14
        alarm_description   = "Critical: Low Open Ports Detected"
        severity            = "Critical"
        namespace           = "DockerStats"
    }
  }
  container_names = [
    "mesh_sitemanager",
    "mesh_sessionprocessor",
    "mesh_webproxy",
    "mesh_addonsvc"
  ]
  alarms = flatten([
    for container in local.container_names : [
      for metric_key, metric in local.docker_metrics : {
        container = container
        metric    = metric
      }
    ]
  ])
}

module "docker_metric_alarms" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/metric_alarm?ref=v1.1.0"
  
  for_each = { for alarm in local.alarms : "${alarm.container}_${alarm.metric.metric_name}_${alarm.metric.severity}" => alarm }

  account_id          = var.account_id
  environment         = var.environment
  region              = var.region
  category            = var.category
  application         = var.application
  ticket              = var.ticket
  repo_url            = var.repo_url
  created_by          = var.created_by
  created_on          = var.created_on
  expiry_date         = var.expiry_date

  name                = "${each.value.container}-container-metrics"
  metric_name         = each.value.metric.metric_name
  alarm_description   = each.value.metric.alarm_description
  severity            = each.value.metric.severity
  comparison_operator = each.value.metric.comparison_operator
  evaluation_periods  = each.value.metric.evaluation_periods
  namespace           = each.value.metric.namespace
  period              = each.value.metric.period
  threshold           = each.value.metric.threshold
  statistic           = each.value.metric.statistic

  dimensions = {
    ContainerName = each.value.container
  }

  alarm_actions = [
    module.sns_topic_paze_sre_alarms.arn,
    data.aws_sns_topic.itops_alarms.arn
  ]
}