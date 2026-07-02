# Declare necessary AWS data sources
data "aws_region" "current" {}

# Declare data sources for the Auto Scaling Groups (ASG)
data "aws_autoscaling_group" "asg_addon_svcs" {
  name = "${local.environment}-${local.region_short_name}-mesh-addon_services-asg"
}

data "aws_autoscaling_group" "asg_session_processor" {
  name = "${local.environment}-${local.region_short_name}-mesh-session_processor-asg"
}

data "aws_autoscaling_group" "asg_site_manager" {
  name = "${local.environment}-${local.region_short_name}-mesh-site_manager-asg"
}

data "aws_autoscaling_group" "asg_web_proxy" {
  name = "${local.environment}-${local.region_short_name}-mesh-web_proxy-asg"
}

# Declare data sources for the Elastic Load Balancers (ELB)
data "aws_lb" "elb_web_proxy" {
  name = "${local.environment}-${local.region_short_name}-mesh-webProxy"
}

data "aws_lb" "elb_site_manager" {
  name = "${local.environment}-${local.region_short_name}-mesh-SiteManager"
}

data "aws_lb_target_group" "sm_tg_2_6030" {
  name = "${local.environment}-${local.region_short_name}-mesh-sm-6030-tg"
}

data "aws_lb_target_group" "sm_tg_1_10200" {
  name = "${local.environment}-${local.region_short_name}-mesh-sm-10200-tg"
}

data "aws_lb_target_group" "elb_tg_web_proxy" {
  name = "${local.environment}-${local.region_short_name}-mesh-wp-10200-tg"
}

data "aws_sqs_queue" "outbound_queue" {  
  name = "${local.environment}-${local.region_short_name}-wallet-card-notification-outbound.fifo"
}

data "aws_sqs_queue" "events_queue" {  
  name = "${local.environment}-${local.region_short_name}-wallet-issuer-events"
}

# # Declare SNS topic data source
#ITOPS sns topic
data "aws_sns_topic" "itops_alarms" {
  name = "${local.environment}-${local.region_short_name}-cloud-engineering-itops-alarm"
}

# Cloudwatch Template File
data "template_file" "cloudwatch_dashboard" {
  template = file("${path.module}/templates/dashboard_asg.tpl")
  vars = {
    region                = var.region
    addon_services        = data.aws_autoscaling_group.asg_addon_svcs.name
    session_processor     = data.aws_autoscaling_group.asg_session_processor.name
    site_manager          = data.aws_autoscaling_group.asg_site_manager.name
    web_proxy             = data.aws_autoscaling_group.asg_web_proxy.name
    elb_web_proxy         = data.aws_lb.elb_web_proxy.name
    elb_site_manager      = data.aws_lb.elb_site_manager.name
    elb_tg_2_site_manager = data.aws_lb_target_group.sm_tg_2_6030.name
    elb_tg_1_site_manager = data.aws_lb_target_group.sm_tg_1_10200.name
    elb_tg_web_proxy      = data.aws_lb_target_group.elb_tg_web_proxy.name
  }
}

# Cloudwatch DockerStats Template File
data "template_file" "docker_dashboard" {
  template = file("${path.module}/templates/dashboard_docker.tpl")
  vars = {
    region                = var.region
    addon_services        = var.container_ids["addon_services"]
    session_processor     = var.container_ids["session_processor"]
    site_manager          = var.container_ids["site_manager"]
    web_proxy             = var.container_ids["web_proxy"]
  }
}

# Cloudwatch DynamoDB Template File
# Declare your DynamoDB table names in the locals block
locals {
  dynamodb_table_names = [
    "${local.environment}-mesh-org-ddb",
    "${local.environment}-mesh-wallet-merchants-ddb",
    "${local.environment}-mesh-wallet-salt-ddb",
    "${local.environment}-wallet-merchant-fls-qualification-ddb",
    "${local.environment}-wallet-merchant-network-name-ddb",
    "${local.environment}-wallet-merchant-network-mid-ddb",
    "${local.environment}-wallet-merchant-key-ddb",
    "${local.environment}-wallet-fls-eligible-transactions-ddb",
    "${local.environment}-wallet-mobile-checkout-sessions-ddb",
    "${local.environment}-wallet-device-attempts-ddb",
    "${local.environment}-wallet-appeals-ddb",
    "${local.environment}-wallet-bank-claims-ddb",
    "${local.environment}-wallet-authentication-events-ddb",
    "${local.environment}-wallet-verification-codes-ddb",
    "${local.environment}-wallet-wms-sessions-ddb",
    "${local.environment}-wallet-terms-ddb",
    "${local.environment}-wallet-fraud-transaction-summary-ddb",
    "${local.environment}-wallet-identifier-ddb",
    "${local.environment}-wallet-fraud-transactions-ddb"
  ]
  kinesis_stream_names = [
    "${local.environment}-usw2-wallet-analytics-kds",
    "${local.environment}-usw2-wallet-business-event-stream",
    "${local.environment}-usw2-wallet-event-stream",
    "${local.environment}-usw2-wallet-input-stream",
    "${local.environment}-usw2-wallet-session-stream"
  ]
}

# Render the template file with the table names and region as variables
data "template_file" "dynamodb_tables_dashboard" {
  template = file("${path.module}/templates/dashboard_ddb.tpl")
  vars = {
    dynamodb_table_names = jsonencode(local.dynamodb_table_names)
    kinesis_stream_names = jsonencode(local.kinesis_stream_names)
    region               = var.region
  }
}

locals {
  dynamodb_data = yamldecode(file("${path.module}/vars.yaml"))
}

# locals {
#   dynamodb_table_stream_labels = local.dynamodb_data["dynamodb_table_stream_labels"]
# }

locals {
  region_short_name = "${join("", slice(split("-", data.aws_region.current.name), 0, 1))}${substr(element(split("-", data.aws_region.current.name), 1), 0, 1)}${substr(data.aws_region.current.name, length(data.aws_region.current.name) - 1, 1)}"
  environment       = replace(var.environment, "app-", "")
}


# lambda code to connect athena
data "archive_file" "observability_check_lambda_code" {
  type        = "zip"
  source_dir  = "${path.module}/observability_check_lambda_code"
  output_path = "${path.module}/observability_check_lambda_code.zip"
}

# lambda code to stream logs to splunk
data "archive_file" "logsmonitor_lambda_code" {
  type        = "zip"
  source_dir  = "${path.module}/logsmonitor_lambda_code"
  output_path = "${path.module}/logsmonitor_lambda_code.zip"
}


# Lambda code for dashboard updater
data "archive_file" "dashboard_updater_lambda_code" {
  type        = "zip"
  source_dir  = "${path.module}/dashboard_updater_lambda_code"
  output_path = "${path.module}/dashboard_updater_lambda_code.zip"
}


# Data Quality lambda code
data "archive_file" "data_quality_lambda_code" {
  type        = "zip"
  source_dir  = "${path.module}/data_quality_lambda_code"
  output_path = "${path.module}/data_quality_lambda_code.zip"
}

