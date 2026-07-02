module "s3_sre_operational_bucket_key" {
  source      = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_kms.git//modules/kms?ref=v1.0.0"
  count       = var.s3_sre_operational_bucket_key != null ? 1 : 0
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
 
  description             = var.s3_sre_operational_bucket_key.description
  deletion_window_in_days = var.s3_sre_operational_bucket_key.deletion_window_in_days
  alias_name              = var.s3_sre_operational_bucket_key.alias_name
  multi_region            = var.s3_sre_operational_bucket_key.multi_region
  policy_shared           = var.s3_sre_operational_bucket_key.policy_shared

}

module "s3_duplicate_wallet_query_results_bucket_key" {
  source       = "git::https://gitlab.ews.int/ceng/tflivem/tf_module_kms.git//modules/kms?ref=v1.0.0"
  count       = var.s3_duplicate_wallet_query_results_bucket_key != null ? 1 : 0
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

  description             = var.s3_duplicate_wallet_query_results_bucket_key.description
  deletion_window_in_days = var.s3_duplicate_wallet_query_results_bucket_key.deletion_window_in_days
  alias_name              = var.s3_duplicate_wallet_query_results_bucket_key.alias_name
  multi_region            = var.s3_duplicate_wallet_query_results_bucket_key.multi_region
  policy_shared           = var.s3_duplicate_wallet_query_results_bucket_key.policy_shared
  
}