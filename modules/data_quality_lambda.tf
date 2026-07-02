// below configuration is for lambda for glue logging to splunk
module "data_quality_lambda" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_lambda.git//modules/lambda?ref=v1.0.0"
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

  name                  = var.data_quality_lambda.name
  description           = var.data_quality_lambda.description
  runtime               = var.data_quality_lambda.runtime
  timeout               = var.data_quality_lambda.timeout
  handler               = var.data_quality_lambda.handler
  subnet_name           = var.data_quality_lambda.subnet_name
  memory                = var.data_quality_lambda.memory
  security_groups       = var.data_quality_lambda.security_groups
  iam_role_arn          = var.data_quality_lambda != null ? module.data_quality_lambda_role[0].arn : "" 
  environment_variables = var.data_quality_lambda.environment_variables
  filename              = data.archive_file.data_quality_lambda_code.output_path
  source_code_hash      = data.archive_file.data_quality_lambda_code.output_base64sha256
  lambda_permission = {
    source_arn = "arn:aws:logs:${var.region}:${var.account_id}:log-group:*"
    action     = "lambda:InvokeFunction"
  }
}
