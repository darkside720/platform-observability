module "cloudwatch_event_iam_sre_role" {
  source                = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_iam.git//modules/iam?ref=v1.5.1"
  count                 = var.cloudwatch_event_iam_sre_role != null ? 1 : 0
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

  name                  = var.cloudwatch_event_iam_sre_role.name
  description           = var.cloudwatch_event_iam_sre_role.description
  iam_policy_s3_keys    = var.cloudwatch_event_iam_sre_role.iam_policy_s3_keys
  assume_role_json_file = var.cloudwatch_event_iam_sre_role.assume_role_json_file
}

module "observability_check_lambda_role" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_iam.git//modules/iam?ref=v1.5.1"
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

  name                   = var.observability_check_lambda.role.name
  description            = var.observability_check_lambda.role.description
  iam_policy_s3_keys     = var.observability_check_lambda.role.iam_policy_s3_keys
  assume_role_json_file  = var.observability_check_lambda.role.assume_role_json_file
  additional_policy_arns = var.observability_check_lambda.role.additional_policy_arns
}

module "logsmonitor_lambda_role" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_iam.git//modules/iam?ref=v1.5.1"
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

  name                   = var.logsmonitor_lambda.role.name
  description            = var.logsmonitor_lambda.role.description
  iam_policy_s3_keys     = var.logsmonitor_lambda.role.iam_policy_s3_keys
  assume_role_json_file  = var.logsmonitor_lambda.role.assume_role_json_file
  additional_policy_arns = var.logsmonitor_lambda.role.additional_policy_arns
}

module "data_quality_cloudwatch_event_bridge_scheduler_role" {
  source                = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_iam.git//modules/iam?ref=v1.5.1"
  count                 = var.data_quality_cloudwatch_event_bridge_scheduler_role != null ? 1 : 0
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

  name                  = var.data_quality_cloudwatch_event_bridge_scheduler_role.name
  description           = var.data_quality_cloudwatch_event_bridge_scheduler_role.description
  iam_policy_s3_keys    = var.data_quality_cloudwatch_event_bridge_scheduler_role.iam_policy_s3_keys
  assume_role_json_file = var.data_quality_cloudwatch_event_bridge_scheduler_role.assume_role_json_file
}

module "data_quality_lambda_role" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_iam.git//modules/iam?ref=v1.5.1"
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

  name                   = var.data_quality_lambda.role.name
  description            = var.data_quality_lambda.role.description
  iam_policy_s3_keys     = var.data_quality_lambda.role.iam_policy_s3_keys
  assume_role_json_file  = var.data_quality_lambda.role.assume_role_json_file
  additional_policy_arns = var.data_quality_lambda.role.additional_policy_arns
}

module "dashboard_updater_event_bridge_scheduler_role" {
  source                = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_iam.git//modules/iam?ref=v1.5.1"
  count                 = var.dashboard_updater_event_bridge_scheduler_role != null ? 1 : 0
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

  name                  = var.dashboard_updater_event_bridge_scheduler_role.name
  description           = var.dashboard_updater_event_bridge_scheduler_role.description
  iam_policy_s3_keys    = var.dashboard_updater_event_bridge_scheduler_role.iam_policy_s3_keys
  assume_role_json_file = var.dashboard_updater_event_bridge_scheduler_role.assume_role_json_file
}

module "dashboard_updater_lambda_role" {
  source                = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_iam.git//modules/iam?ref=v1.5.1"
  count                 = var.dashboard_updater_lambda != null ? 1 : 0
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

  name                   = var.dashboard_updater_lambda.role.name
  description            = var.dashboard_updater_lambda.role.description
  iam_policy_s3_keys     = var.dashboard_updater_lambda.role.iam_policy_s3_keys
  assume_role_json_file  = var.dashboard_updater_lambda.role.assume_role_json_file
  additional_policy_arns = var.dashboard_updater_lambda.role.additional_policy_arns
}
