provider "aws" {
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/AssumeRoleHarness"
  }
}

terraform {
  required_providers {
    aws = {
      source  = "artifactory.ews.int/releases-hashicorp/aws"
      version = "~> 4.16"
    }
    template = {
      source  = "artifactory.ews.int/releases-hashicorp/template"
      version = "~> 2.1"
    }
    archive = {
      source  = "artifactory.ews.int/releases-hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

