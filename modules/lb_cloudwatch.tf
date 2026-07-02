locals {
  nlb_metrices = [
    {
      metric_name         = "UnHealthyHostCount"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Maximum"
      threshold           = 1
      alarm_description   = "Maximum UnHealthy Host Count"
      severity            = "Critical"
    }
  ]
}

module "site_manager_nlb_metric_alarm" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/metric_alarm?ref=v1.1.0"

  count = length(local.nlb_metrices)

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

  name                = "mesh-site_manager-asg-sre"
  severity            = local.nlb_metrices[count.index].severity
  comparison_operator = local.nlb_metrices[count.index].comparison_operator
  evaluation_periods  = local.nlb_metrices[count.index].evaluation_periods
  metric_name         = local.nlb_metrices[count.index].metric_name
  namespace           = "AWS/NetworkELB"
  period              = local.nlb_metrices[count.index].period
  statistic           = local.nlb_metrices[count.index].statistic

  threshold = local.nlb_metrices[count.index].threshold

  dimensions = {
    TargetGroup  = data.aws_lb_target_group.sm_tg_1_10200.arn_suffix
    LoadBalancer = data.aws_lb.elb_site_manager.arn_suffix
  }

  alarm_description = local.nlb_metrices[count.index].alarm_description
  alarm_actions     = [
    module.sns_topic_paze_sre_alarms.arn, 
    data.aws_sns_topic.itops_alarms.arn
    ]
}

module "web_proxy_nlb_metric_alarm" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/metric_alarm?ref=v1.1.0"

  count = length(local.nlb_metrices)

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

  name                = "mesh-web_proxy-asg-sre"
  severity            = local.nlb_metrices[count.index].severity
  comparison_operator = local.nlb_metrices[count.index].comparison_operator
  evaluation_periods  = local.nlb_metrices[count.index].evaluation_periods
  metric_name         = local.nlb_metrices[count.index].metric_name
  namespace           = "AWS/ApplicationELB"
  period              = local.nlb_metrices[count.index].period
  statistic           = local.nlb_metrices[count.index].statistic

  threshold = local.nlb_metrices[count.index].threshold

  dimensions = {
    TargetGroup = data.aws_lb_target_group.elb_tg_web_proxy.arn_suffix
    LoadBalancer = data.aws_lb.elb_web_proxy.arn_suffix
  }

  alarm_description = local.nlb_metrices[count.index].alarm_description
  alarm_actions     = [
    module.sns_topic_paze_sre_alarms.arn, 
    data.aws_sns_topic.itops_alarms.arn
    ]
}
