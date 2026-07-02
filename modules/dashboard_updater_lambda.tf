module "dashboard_updater_lambda" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_lambda.git//modules/lambda?ref=v1.0.0"
  count       = var.dashboard_updater_lambda != null ? 1 : 0
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

  name                  = var.dashboard_updater_lambda.name
  description           = var.dashboard_updater_lambda.description
  runtime               = var.dashboard_updater_lambda.runtime
  timeout               = var.dashboard_updater_lambda.timeout
  handler               = var.dashboard_updater_lambda.handler
  subnet_name           = var.dashboard_updater_lambda.subnet_name
  memory                = var.dashboard_updater_lambda.memory
  security_groups       = var.dashboard_updater_lambda.security_groups
  iam_role_arn          = module.dashboard_updater_lambda_role[0].arn
  environment_variables = var.dashboard_updater_lambda.environment_variables
  filename              = data.archive_file.dashboard_updater_lambda_code.output_path
  source_code_hash      = data.archive_file.dashboard_updater_lambda_code.output_base64sha256

}
