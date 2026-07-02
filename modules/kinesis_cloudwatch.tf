locals {
  # Load YAML file
  kinesis_streams_thresholds = yamldecode(file("${path.module}/vars.yaml"))

  # Extract Kinesis streams with thresholds from YAML
  kinesis_streams = local.kinesis_streams_thresholds.kinesis_streams

  # Define metrics for Kinesis Data Streams
  kinesis_metrics = [
    {
      metric_name         = "GetRecords.Bytes"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Sum"
      alarm_description   = "Alarm when GetRecords.Bytes exceeds the threshold"
      severity            = "Critical"
    },
    {
      metric_name         = "GetRecords.IteratorAgeMilliseconds"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Maximum"
      alarm_description   = "Alarm when GetRecords.IteratorAgeMilliseconds exceeds the threshold"
      severity            = "Critical"
    },
    {
      metric_name         = "GetRecords.Latency"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Average"
      alarm_description   = "Alarm when GetRecords.Latency exceeds the threshold"
      severity            = "Warning"
    },
    {
      metric_name         = "GetRecords.Records"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Sum"
      alarm_description   = "Alarm when GetRecords.Records exceeds the threshold"
      severity            = "Critical"
    },
    {
      metric_name         = "PutRecords.FailedRecords"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Sum"
      alarm_description   = "Alarm when PutRecords.FailedRecords exceeds the threshold"
      severity            = "Critical"
    },
    {
      metric_name         = "PutRecords.TotalRecords"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Sum"
      alarm_description   = "Alarm when PutRecords.TotalRecords exceeds the threshold"
      severity            = "Critical"
    },
    {
      metric_name         = "PutRecords.FailedRecords.Percent"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Average"
      alarm_description   = "Alarm when PutRecords.FailedRecords.Percent exceeds the threshold"
      severity            = "Warning"
    },
    {
      metric_name         = "WriteProvisionedThroughputExceeded"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Average"
      alarm_description   = "Alarm when WriteProvisionedThroughputExceeded exceeds the threshold"
      severity            = "Critical"
    },
    {
      metric_name         = "PutRecords.ThrottleRecords"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Sum"
      alarm_description   = "Alarm when PutRecords.ThrottleRecords exceeds the threshold"
      severity            = "Critical"
    }
  ]

  # Create a list of all combinations of streams and metrics
  kinesis_alarms = flatten([
    for stream in local.kinesis_streams : [
      for metric in local.kinesis_metrics : {
        stream_name          = stream.name
        metric_name          = metric.metric_name
        comparison_operator  = metric.comparison_operator
        evaluation_periods   = metric.evaluation_periods
        period               = metric.period
        statistic            = metric.statistic
        threshold            = lookup(
          { for m in stream.metrics : m.metric_name => m.threshold },
          metric.metric_name,
          0
        )
        alarm_description    = "${metric.alarm_description} for stream ${stream.name}"
        severity             = metric.severity
      }
    ]
  ])
}

module "kinesis_metric_alarms" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/metric_alarm?ref=v1.1.0"

  for_each = { for alarm in local.kinesis_alarms : "${alarm.stream_name}-${alarm.metric_name}" => alarm }

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

  name                = "${each.value.stream_name}-${each.value.metric_name}-alarm"
  severity            = each.value.severity
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = "AWS/Kinesis"
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold

  dimensions = {
    StreamName = each.value.stream_name
  }

#   alarm_description = each.value.alarm_description
#   alarm_actions     = [
#     module.sns_topic_sre_sre_alarms.arn
#   ]
}
