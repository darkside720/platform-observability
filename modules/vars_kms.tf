variable "s3_sre_operational_bucket_key" {
  default = null
  type = object({
    description             = string
    deletion_window_in_days = number
    alias_name              = string
    multi_region            = bool
    policy_shared           = bool
  })
}

variable "s3_duplicate_wallet_query_results_bucket_key" {
  default = null
  type = object({
    description             = string
    deletion_window_in_days = number
    alias_name              = string
    multi_region            = bool
    policy_shared           = bool
  })
}

