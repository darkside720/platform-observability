# bucket that holds csv file with SQL query
module "s3_sre_operational_bucket" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_s3.git//modules/s3?ref=v1.11.0"
  count       = var.s3_sre_operational_bucket != null ? 1 : 0
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

 
  name                    = var.s3_sre_operational_bucket.name
  versioning              = var.s3_sre_operational_bucket.versioning
  lifecycle_configuration = var.s3_sre_operational_bucket.lifecycle_configuration
  cloudfront_oai_id       = var.s3_sre_operational_bucket.cloudfront_oai_id
  management_account_id   = var.s3_sre_operational_bucket.management_account_id
  kms_key_arn             = var.s3_sre_operational_bucket != null ? module.s3_sre_operational_bucket_key[0].arn : ""

}

# bucket that holds csv file with SQL query
module "s3_duplicate_wallet_query_results_bucket" {
  source = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_s3.git//modules/s3?ref=v1.11.0"
  count       = var.s3_duplicate_wallet_query_results_bucket != null ? 1 : 0
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

  name                    = var.s3_duplicate_wallet_query_results_bucket.name
  versioning              = var.s3_duplicate_wallet_query_results_bucket.versioning
  lifecycle_configuration = var.s3_duplicate_wallet_query_results_bucket.lifecycle_configuration
  cloudfront_oai_id       = var.s3_duplicate_wallet_query_results_bucket.cloudfront_oai_id
  management_account_id   = var.s3_duplicate_wallet_query_results_bucket.management_account_id
  kms_key_arn             = var.s3_duplicate_wallet_query_results_bucket != null ? module.s3_duplicate_wallet_query_results_bucket_key[0].arn : ""
}