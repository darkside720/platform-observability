include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../..//modules"
}

locals {
  vars    = yamldecode(file("vars.yaml"))

  pipeline_parameters = {
    account_id          = get_env("TF_VAR_ACCOUNT_ID", "")
    environment         = get_env("TF_VAR_ENVIRONMENT", "")
    region              = get_env("TF_VAR_REGION", "us-east-1")
    category            = get_env("TF_VAR_CATEGORY", "")
    application         = get_env("TF_VAR_APPLICATION", "")
    ticket              = get_env("TF_VAR_TICKET", "")
    repo_url            = get_env("TF_VAR_REPO_URL", "")
    created_by          = get_env("TF_VAR_CREATED_BY", "")
    created_on          = get_env("TF_VAR_CREATED_ON", "")
    expiry_date         = get_env("TF_VAR_EXPIRY_DATE", "2099-12-31")
  }
}

inputs = {
  account_id          = local.pipeline_parameters.account_id
  environment         = local.pipeline_parameters.environment
  region              = local.pipeline_parameters.region
  category            = local.pipeline_parameters.category
  application         = local.pipeline_parameters.application
  ticket              = local.pipeline_parameters.ticket
  repo_url            = local.pipeline_parameters.repo_url
  created_by          = local.pipeline_parameters.created_by
  created_on          = local.pipeline_parameters.created_on
  expiry_date         = local.pipeline_parameters.expiry_date

  # Pass the r53_health_checks variable from vars.yaml to the inputs
  r53_health_checks = local.vars.r53_health_checks
}
