// below configuration is for lambda for glue logging to splunk
module "logsmonitor_lambda" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_lambda.git//modules/lambda?ref=v1.0.0"
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

 

  name                  = var.logsmonitor_lambda.name
  description           = var.logsmonitor_lambda.description
  runtime               = var.logsmonitor_lambda.runtime
  timeout               = var.logsmonitor_lambda.timeout
  handler               = var.logsmonitor_lambda.handler
  subnet_name           = var.logsmonitor_lambda.subnet_name
  memory                = var.logsmonitor_lambda.memory
  security_groups       = var.logsmonitor_lambda.security_groups
  iam_role_arn          = var.logsmonitor_lambda != null ? module.logsmonitor_lambda_role[0].arn : ""
  environment_variables = var.logsmonitor_lambda.environment_variables
  filename              = data.archive_file.logsmonitor_lambda_code.output_path
  source_code_hash      = data.archive_file.logsmonitor_lambda_code.output_base64sha256
  lambda_permission = {
    source_arn = "arn:aws:logs:${var.region}:${var.account_id}:log-group:*"
    action     = "lambda:InvokeFunction"
  }
}