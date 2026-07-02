locals {
  sns_subscription_paze_sre_alarms = var.sns_subscription_paze_sre_alarms
  sns_subscription_paze_orchestration_team_endpoint = var.sns_subscription_paze_orchestration_team_endpoint
}

module "temp_sns_topic_paze_sre_alarms" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_sns.git//modules/sns/topic?ref=v1.0.0"

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

  name         = var.temp_sns_topic_paze_sre_alarms.name
  display_name = var.temp_sns_topic_paze_sre_alarms.display_name
}

module "temp_sns_subscription_sre" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_sns.git//modules/sns/subscription?ref=v1.1.0"

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

  topic_arn = module.temp_sns_topic_paze_sre_alarms.arn
  protocol  = var.temp_sns_subscription_paze_sre_alarms.protocol
  endpoint  = var.temp_sns_subscription_paze_sre_alarms.endpoint
}
module "sns_topic_paze_sre_alarms" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_sns.git//modules/sns/topic?ref=v1.0.0"

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

  name         = var.sns_topic_paze_sre_alarms.name
  display_name = var.sns_topic_paze_sre_alarms.display_name
}

module "sns_subscription_sre" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_sns.git//modules/sns/subscription?ref=v1.1.0"

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

  topic_arn = module.sns_topic_paze_sre_alarms.arn
  protocol  = local.sns_subscription_paze_sre_alarms.protocol
  endpoint  = local.sns_subscription_paze_sre_alarms.endpoint
}

module "sns_topic_paze_orchestration_team" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_sns.git//modules/sns/topic?ref=v1.0.0"

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

  name         = var.sns_topic_paze_orchestration_team_endpoint.name
  display_name = var.sns_topic_paze_orchestration_team_endpoint.display_name
}

module "sns_subscription_pazo_orchestration" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_sns.git//modules/sns/subscription?ref=v1.1.0"

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

  topic_arn = module.sns_topic_paze_orchestration_team.arn
  protocol  = local.sns_subscription_paze_orchestration_team_endpoint.protocol
  endpoint  = local.sns_subscription_paze_orchestration_team_endpoint.endpoint
}