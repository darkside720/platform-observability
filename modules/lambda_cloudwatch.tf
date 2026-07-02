module "observability_check_lambda_log_group" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/log_group?ref=v1.0.0"
  count       = var.observability_check_lambda != null ? 1 : 0
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

  name              = var.observability_check_lambda != null ? "${var.observability_check_lambda.log_group.name}${module.observability_check_lambda[0].lambda_function_name}" : ""
  retention_in_days = var.observability_check_lambda.log_group.retention_in_days
  skip_destroy      = var.observability_check_lambda.log_group.skip_destroy
  kms_key_id        = var.observability_check_lambda.log_group.kms_key_id
}

module "lambdalogs_lambda_log_group" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/log_group?ref=v1.0.0"
  count       = var.logsmonitor_lambda != null ? 1 : 0
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

  name              = var.logsmonitor_lambda != null ? "${var.logsmonitor_lambda.log_group.name}${module.logsmonitor_lambda[0].lambda_function_name}" : ""
  retention_in_days = var.logsmonitor_lambda.log_group.retention_in_days
  skip_destroy      = var.logsmonitor_lambda.log_group.skip_destroy
  kms_key_id        = var.logsmonitor_lambda.log_group.kms_key_id
}

module "logsmonitor_lambdaoutput_subscriptions" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/log_subscription_filter?ref=v1.0.0"
  count       = var.logsmonitor_lambdaoutput_subscriptions != null ? 1 : 0
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

  name            = var.logsmonitor_lambdaoutput_subscriptions.name
  role_arn        = var.logsmonitor_lambdaoutput_subscriptions.role_arn
  log_group_name  = var.logsmonitor_lambdaoutput_subscriptions.log_group_name
  filter_pattern  = var.logsmonitor_lambdaoutput_subscriptions.filter_pattern
  destination_arn = var.logsmonitor_lambdaoutput_subscriptions != null ? module.logsmonitor_lambda[0].lambda_arn : ""
  distribution    = var.logsmonitor_lambdaoutput_subscriptions.distribution
}



module "data_quality_lambda_log_group" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/log_group?ref=v1.0.0"
  count       = var.data_quality_lambda != null ? 1 : 0
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

  name              = var.data_quality_lambda != null ? "${var.data_quality_lambda.log_group.name}${module.data_quality_lambda[0].lambda_function_name}" : ""
  retention_in_days = var.data_quality_lambda.log_group.retention_in_days
  skip_destroy      = var.data_quality_lambda.log_group.skip_destroy
  kms_key_id        = var.data_quality_lambda.log_group.kms_key_id
}

module "data_quality_lambda_logs_subscriptions" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch.git//modules/cloudwatch/log_subscription_filter?ref=v1.0.0"
  count       = var.data_quality_lambda_logs_subscriptions != null ? 1 : 0
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

  name            = var.data_quality_lambda_logs_subscriptions.name
  role_arn        = var.data_quality_lambda_logs_subscriptions.role_arn
  log_group_name  = var.data_quality_lambda_logs_subscriptions.log_group_name
  filter_pattern  = var.data_quality_lambda_logs_subscriptions.filter_pattern
  destination_arn = var.data_quality_lambda_logs_subscriptions != null ? module.logsmonitor_lambda[0].lambda_arn : ""
  distribution    = var.data_quality_lambda_logs_subscriptions.distribution
}
