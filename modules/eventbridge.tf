module "eventbridge-scheduler-sre" {
  source                = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_eventbridge.git//modules/event_scheduler?ref=v1.3.0"
  count                 = var.eventbridge-scheduler-sre != null ? 1 : 0
  account_id            = var.account_id
  environment           = var.environment
  region                = var.region
  category              = var.category
  application           = var.application
  ticket                = var.ticket
  repo_url              = var.repo_url
  created_by            = var.created_by
  created_on            = var.created_on
  expiry_date           = var.expiry_date
  
  name                         = var.eventbridge-scheduler-sre.name
  schedule_expression          = var.eventbridge-scheduler-sre.schedule_expression
  schedule_expression_timezone = var.eventbridge-scheduler-sre.schedule_expression_timezone
  flexible_time_window         = var.eventbridge-scheduler-sre.flexible_time_window
  target                = {
    arn      = var.eventbridge-scheduler-sre != null ? module.observability_check_lambda[0].lambda_arn : ""
    role_arn = var.eventbridge-scheduler-sre != null ? module.cloudwatch_event_iam_sre_role[0].arn : ""
    input    = var.eventbridge-scheduler-sre != null ? "{\"FunctionName\": \"${module.observability_check_lambda[0].lambda_arn}\",  \"InvocationType\": \"Event\", \"Payload\": \"\"}" : ""
  }
}

module "data_quality_event_bridge_scheduler" {
  source                = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_eventbridge.git//modules/event_scheduler?ref=v1.3.0"
  count                 = var.data_quality_event_bridge_scheduler != null ? 1 : 0
  account_id            = var.account_id
  environment           = var.environment
  region                = var.region
  category              = var.category
  application           = var.application
  ticket                = var.ticket
  repo_url              = var.repo_url
  created_by            = var.created_by
  created_on            = var.created_on
  expiry_date           = var.expiry_date
  
  name                         = var.data_quality_event_bridge_scheduler.name
  schedule_expression          = var.data_quality_event_bridge_scheduler.schedule_expression
  schedule_expression_timezone = var.data_quality_event_bridge_scheduler.schedule_expression_timezone
  flexible_time_window         = var.data_quality_event_bridge_scheduler.flexible_time_window
  target                = {
    arn      = var.data_quality_event_bridge_scheduler != null ? module.data_quality_lambda[0].lambda_arn : ""
    role_arn = var.data_quality_event_bridge_scheduler != null ? module.data_quality_cloudwatch_event_bridge_scheduler_role[0].arn : ""
    input    = var.data_quality_event_bridge_scheduler != null ? "{\"FunctionName\": \"${module.data_quality_lambda[0].lambda_arn}\",  \"InvocationType\": \"Event\", \"Payload\": \"\"}" : ""
  }
  depends_on = [ module.data_quality_lambda, module.data_quality_cloudwatch_event_bridge_scheduler_role ]
}

module "dashboard_updater_event_bridge_scheduler" {
  source                = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_eventbridge.git//modules/event_scheduler?ref=v1.3.0"
  count                 = var.dashboard_updater_event_bridge_scheduler != null ? 1 : 0
  account_id            = var.account_id
  environment           = var.environment
  region                = var.region
  category              = var.category
  application           = var.application
  ticket                = var.ticket
  repo_url              = var.repo_url
  created_by            = var.created_by
  created_on            = var.created_on
  expiry_date           = var.expiry_date

  name                         = var.dashboard_updater_event_bridge_scheduler.name
  schedule_expression          = var.dashboard_updater_event_bridge_scheduler.schedule_expression
  schedule_expression_timezone = var.dashboard_updater_event_bridge_scheduler.schedule_expression_timezone
  flexible_time_window         = var.dashboard_updater_event_bridge_scheduler.flexible_time_window
  target = {
    arn      = module.dashboard_updater_lambda[0].lambda_arn
    role_arn = module.dashboard_updater_event_bridge_scheduler_role[0].arn
    input    = "{\"FunctionName\": \"${module.dashboard_updater_lambda[0].lambda_arn}\", \"InvocationType\": \"Event\", \"Payload\": \"\"}"
  }
}