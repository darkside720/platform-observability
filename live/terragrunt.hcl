generate "partial_s3_backend" {
  path      = "terraform.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  backend "s3" {}
}
EOF
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "ews-tf-${get_env("TF_VAR_REGION", "")}-management"
    key            = "${get_env("TF_VAR_CATEGORY", "")}/${get_env("TF_VAR_ENVIRONMENT", "")}/${get_env("TF_VAR_APPLICATION", "")}/${get_env("TF_VAR_REGION_FOLDER", "")}/${get_env("TF_VAR_MODULE", "")}/terraform.tfstate"
    region         = "${get_env("TF_VAR_REGION", "")}"
    encrypt        = true
    kms_key_id     = "alias/ews-tf-${get_env("TF_VAR_REGION", "")}-management-s3-key"
    dynamodb_table = "terraform-locks"
    skip_bucket_root_access  = true
    skip_bucket_enforced_tls = true
    disable_bucket_update    = true
  }
}