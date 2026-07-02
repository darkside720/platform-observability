locals {
  metrices = [

    #Critical

    {
      metric_name         = "CPUUtilization"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Average"
      unit                = "Percent"
      threshold           = 90
      alarm_description   = "CPU Utilization Average Percent"
      severity            = "Critical"
    },
    {
      metric_name         = "disk_used_percent"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Average"
      unit                = "Percent"
      namespace           = "CWAgent"
      threshold           = 90
      alarm_description   = "Disk space Average Percent"
      severity            = "Critical"
    },
    {
      metric_name         = "mem_used_percent"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Average"
      unit                = "Percent"
      namespace           = "CWAgent"
      threshold           = 90
      alarm_description   = "Memory Average Percent"
      severity            = "Critical"
    },

    # Warning

    {
      metric_name         = "CPUUtilization"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Average"
      unit                = "Percent"
      threshold           = 85
      alarm_description   = "CPU Utilization Average Percent"
      severity            = "Warning"
    },
    {
      metric_name         = "disk_used_percent"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Average"
      unit                = "Percent"
      namespace           = "CWAgent"
      threshold           = 85
      alarm_description   = "Disk space Average Percent"
      severity            = "Warning"
    },
    {
      metric_name         = "mem_used_percent"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Average"
      unit                = "Percent"
      namespace           = "CWAgent"
      threshold           = 85
      alarm_description   = "Memory Average Percent"
      severity            = "Warning"
    },

    #Informational

    {
      metric_name         = "CPUUtilization"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Average"
      unit                = "Percent"
      threshold           = 75
      alarm_description   = "CPU Utilization Average Percent"
      severity            = "Informational"
    },
    {
      metric_name         = "disk_used_percent"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Average"
      unit                = "Percent"
      namespace           = "CWAgent"
      threshold           = 75
      alarm_description   = "Disk space Average Percent"
      severity            = "Informational"
    },
    {
      metric_name         = "mem_used_percent"
      comparison_operator = "GreaterThanOrEqualToThreshold"
      evaluation_periods  = 3
      period              = 300
      statistic           = "Average"
      unit                = "Percent"
      namespace           = "CWAgent"
      threshold           = 75
      alarm_description   = "Memory Average Percent"
      severity            = "Informational"
    }
  ]
}

module "site_manager_metric_alarm" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/metric_alarm?ref=v1.1.0"

  count = length(local.metrices)

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
  severity            = local.metrices[count.index].severity
  comparison_operator = local.metrices[count.index].comparison_operator
  evaluation_periods  = local.metrices[count.index].evaluation_periods
  metric_name         = local.metrices[count.index].metric_name
  namespace           = lookup(local.metrices[count.index], "namespace", "AWS/EC2")
  period              = local.metrices[count.index].period
  statistic           = local.metrices[count.index].statistic
  #unit                = local.metrices[count.index].unit

  threshold = local.metrices[count.index].threshold

  dimensions = {
    AutoScalingGroupName = "${local.environment}-${local.region_short_name}-mesh-site_manager-asg"
  }

  alarm_description = local.metrices[count.index].alarm_description
  alarm_actions     = [
    module.sns_topic_paze_sre_alarms.arn, 
    data.aws_sns_topic.itops_alarms.arn
    ]
}

module "session_processor_metric_alarm" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/metric_alarm?ref=v1.1.0"

  count = length(local.metrices)

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

  name                = "mesh-session_processor-asg-sre"
  severity            = local.metrices[count.index].severity
  comparison_operator = local.metrices[count.index].comparison_operator
  evaluation_periods  = local.metrices[count.index].evaluation_periods
  metric_name         = local.metrices[count.index].metric_name
  namespace           = lookup(local.metrices[count.index], "namespace", "AWS/EC2")
  period              = local.metrices[count.index].period
  statistic           = local.metrices[count.index].statistic
  #unit                = local.metrices[count.index].unit

  threshold = local.metrices[count.index].threshold

  dimensions = {
    AutoScalingGroupName = data.aws_autoscaling_group.asg_session_processor.name
  }

  alarm_description = local.metrices[count.index].alarm_description
  alarm_actions     = [
    module.sns_topic_paze_sre_alarms.arn, 
    data.aws_sns_topic.itops_alarms.arn
    ]
}

module "web_proxy_metric_alarm" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/metric_alarm?ref=v1.1.0"

  count = length(local.metrices)

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
  severity            = local.metrices[count.index].severity
  comparison_operator = local.metrices[count.index].comparison_operator
  evaluation_periods  = local.metrices[count.index].evaluation_periods
  metric_name         = local.metrices[count.index].metric_name
  namespace           = lookup(local.metrices[count.index], "namespace", "AWS/EC2")
  period              = local.metrices[count.index].period
  statistic           = local.metrices[count.index].statistic
  #unit                = local.metrices[count.index].unit

  threshold = local.metrices[count.index].threshold

  dimensions = {
    AutoScalingGroupName = data.aws_autoscaling_group.asg_web_proxy.name
  }
  alarm_description = local.metrices[count.index].alarm_description
  alarm_actions     = [
    module.sns_topic_paze_sre_alarms.arn, 
    data.aws_sns_topic.itops_alarms.arn
    ]
}

module "addon_svcs_metric_alarm" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/metric_alarm?ref=v1.1.0"

  count = length(local.metrices)

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

  name                = "mesh-addon_services-asg-sre"
  severity            = local.metrices[count.index].severity
  comparison_operator = local.metrices[count.index].comparison_operator
  evaluation_periods  = local.metrices[count.index].evaluation_periods
  metric_name         = local.metrices[count.index].metric_name
  namespace           = lookup(local.metrices[count.index], "namespace", "AWS/EC2")
  period              = local.metrices[count.index].period
  statistic           = local.metrices[count.index].statistic
  #unit                = local.metrices[count.index].unit

  threshold = local.metrices[count.index].threshold

  dimensions = {
    AutoScalingGroupName = data.aws_autoscaling_group.asg_addon_svcs.name
  }

  alarm_description = local.metrices[count.index].alarm_description
  alarm_actions     = [
    module.sns_topic_paze_sre_alarms.arn, 
    data.aws_sns_topic.itops_alarms.arn
    ]
}
