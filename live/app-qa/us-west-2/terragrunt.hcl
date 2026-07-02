include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../..//modules"
}

locals {
  vars = yamldecode(file("vars.yaml"))

  pipeline_parameters = {
    account_id  = get_env("TF_VAR_ACCOUNT_ID", "")
    environment = get_env("TF_VAR_ENVIRONMENT", "")
    region      = get_env("TF_VAR_REGION", "us-west-2")
    category    = get_env("TF_VAR_CATEGORY", "")
    application = "wallet" #get_env("TF_VAR_APPLICATION", "")
    ticket      = get_env("TF_VAR_TICKET", "")
    repo_url    = get_env("TF_VAR_REPO_URL", "")
    created_by  = get_env("TF_VAR_CREATED_BY", "")
    created_on  = get_env("TF_VAR_CREATED_ON", "")
    expiry_date = get_env("TF_VAR_EXPIRY_DATE", "2099-12-31")
  }
}

inputs = {
  account_id  = local.pipeline_parameters.account_id
  environment = local.pipeline_parameters.environment
  region      = local.pipeline_parameters.region
  category    = local.pipeline_parameters.category
  application = local.pipeline_parameters.application
  ticket      = local.pipeline_parameters.ticket
  repo_url    = local.pipeline_parameters.repo_url
  created_by  = local.pipeline_parameters.created_by
  created_on  = local.pipeline_parameters.created_on
  expiry_date = local.pipeline_parameters.expiry_date

  s3_sre_operational_bucket             = local.vars.s3_sre_operational_bucket
  s3_sre_operational_bucket_key         = local.vars.s3_sre_operational_bucket_key

  s3_duplicate_wallet_query_results_bucket             = local.vars.s3_duplicate_wallet_query_results_bucket
  s3_duplicate_wallet_query_results_bucket_key         = local.vars.s3_duplicate_wallet_query_results_bucket_key

  logsmonitor_lambda                       = local.vars.logsmonitor_lambda
  logsmonitor_lambdaoutput_subscriptions   = local.vars.logsmonitor_lambdaoutput_subscriptions
  observability_check_lambda               = local.vars.observability_check_lambda

  cloudwatch_event_iam_sre_role = local.vars.cloudwatch_event_iam_sre_role
  eventbridge-scheduler-sre = local.vars.eventbridge-scheduler-sre

    # Pass the r53_health_checks variable from vars.yaml to the inputs
  r53_health_checks = local.vars.r53_health_checks

  # Dashboard Updater Lambda
  dashboard_updater_event_bridge_scheduler_role = local.vars.dashboard_updater_event_bridge_scheduler_role
  dashboard_updater_event_bridge_scheduler      = local.vars.dashboard_updater_event_bridge_scheduler
  dashboard_updater_lambda                      = local.vars.dashboard_updater_lambda
  dashboard_updater_lambda_logs_subscriptions   = local.vars.dashboard_updater_lambda_logs_subscriptions

  # Data Quality lambda variable
  data_quality_cloudwatch_event_bridge_scheduler_role = local.vars.data_quality_cloudwatch_event_bridge_scheduler_role
  data_quality_event_bridge_scheduler                 = local.vars.data_quality_event_bridge_scheduler
  data_quality_lambda                                 = local.vars.data_quality_lambda
  data_quality_lambda_logs_subscriptions              = local.vars.data_quality_lambda_logs_subscriptions
   
  # Cloudwatch Alerts
  sre_cloudwatch_alert                 = local.vars.sre_cloudwatch_alert

}
