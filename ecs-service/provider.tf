terraform {
  required_version = "~> 0.14"
}

provider "aws" {
  region = var.region[local.workspace]
  assume_role {
    role_arn     = var.account_role
    external_id  = var.external_id
    session_name = "terraform"
  }
  allowed_account_ids = var.allowed_account_ids
}
