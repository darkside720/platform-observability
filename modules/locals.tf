locals {
  region_split      = split("-", var.region)
  environment_split = split("-", var.environment)
  created_by_split  = split(" | ", var.created_by)

  # environment       = length(local.environment_split) == 2 ? local.environment_split[1] : var.environment
  # region_short_name = length(local.region_split) == 3 ? "${local.region_split[0]}${substr(local.region_split[1], 0, 1)}${substr(local.region_split[2], 0, 1)}" : var.region

  resource_name_prefix = "${local.environment}-${local.region_short_name}-${var.category}"

  created_by    = length(local.created_by_split) > 1 ? replace(local.created_by_split[0], ",", "") : replace(var.created_by, ",", "")
  pipeline_name = length(local.created_by_split) > 1 ? local.created_by_split[1] : ""

  mandatory_tags = {
    "ews:created-by"        = local.created_by
    "ews:born-on-date"      = var.created_on
    "ews:repo-url"          = var.repo_url
    "ews:application"       = var.application
    "ews:category"          = var.category
    "ews:environment"       = var.environment
    "ews:ticket"            = var.ticket
    "ews:pipeline-name"     = local.pipeline_name
    "ews:modified-by"       = local.created_by
    "ews:modified-date"     = var.created_on
    "ews:expiry-date"       = var.expiry_date
    "ews:terraform-managed" = true
  }

    tags = merge(local.mandatory_tags, var.extra_tags)

}
