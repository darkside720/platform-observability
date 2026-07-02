locals {
  sqs_metrics = {
    high = {
      metric_name         = "ApproximateNumberOfMessagesVisible"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Average"
      unit                = "count"
      threshold           = 550000
      alarm_description   = "Alarm when there are more than 250 messages visible in the SQS queue"
      severity            = "Critical"
    },
    medium = {
      metric_name         = "ApproximateNumberOfMessagesNotVisible"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Average"
      unit                = "count"
      threshold           = 10000
      alarm_description   = "Alarm when the age of the oldest message exceeds 5 minutes"
      severity            = "Warning"
    }
  }
}

# Module for the outbound_queue
module "sqs_card_notification_alarm_outbound_queue" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/metric_alarm?ref=v1.1.0"

  for_each = local.sqs_metrics

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

  name                  = replace(data.aws_sqs_queue.outbound_queue.name, "${local.environment}-${local.region_short_name}-", "")
  severity              = each.value.severity
  comparison_operator   = each.value.comparison_operator
  evaluation_periods    = each.value.evaluation_periods
  metric_name           = each.value.metric_name
  namespace             = "AWS/SQS"
  statistic             = each.value.statistic
  period                = each.value.period
  threshold             = each.value.threshold

  dimensions = {
    QueueName = data.aws_sqs_queue.outbound_queue.name
  }

  alarm_description = each.value.alarm_description
  alarm_actions     = [
    module.temp_sns_topic_paze_sre_alarms.arn,
    data.aws_sns_topic.itops_alarms.arn
  ]
}

# Module for the wallet-issuer-events queue
module "sqs_card_notification_alarm_issuer_events_queue" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/metric_alarm?ref=v1.1.0"

  for_each = local.sqs_metrics

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

  name                  = replace(data.aws_sqs_queue.events_queue.name, "${local.environment}-${local.region_short_name}-", "")
  severity              = each.value.severity
  comparison_operator   = each.value.comparison_operator
  evaluation_periods    = each.value.evaluation_periods
  metric_name           = each.value.metric_name
  namespace             = "AWS/SQS"
  statistic             = each.value.statistic
  period                = each.value.period
  threshold             = each.value.threshold

  dimensions = {
    QueueName = data.aws_sqs_queue.events_queue.name
  }

  alarm_description = each.value.alarm_description
  alarm_actions     = [
    module.temp_sns_topic_paze_sre_alarms.arn,
    data.aws_sns_topic.itops_alarms.arn
  ]
}
