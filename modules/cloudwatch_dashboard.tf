module "cloudwatch_dashboard" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch_dashboard.git//modules/cloudwatch_dashboard?ref=v1.0.0"

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

  name = var.application
  body = data.template_file.cloudwatch_dashboard.rendered
}
module "docker_cloudwatch_dashboard" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch_dashboard.git//modules/cloudwatch_dashboard?ref=v1.0.0"

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

  name = "${var.application}-docker_dashboard"
  body = data.template_file.docker_dashboard.rendered
}

  module "ddb_cloudwatch_dashboard" {  
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_cloudwatch_dashboard.git//modules/cloudwatch_dashboard?ref=v1.0.0"
  
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

  name = "${var.application}-dynamodb_tables_dashboard"
  body = data.template_file.dynamodb_tables_dashboard.rendered
}
