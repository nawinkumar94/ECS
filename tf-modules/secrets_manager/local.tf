locals {

  secrets = [
    for secret in var.secrets : {
      name                    = lookup(secret, "name", "${var.env}/secret_string")
      name_prefix             = lookup(secret, "name_prefix", null)
      description             = lookup(secret, "description", null)
      kms_key_id              = lookup(secret, "kms_key_id", "aws/secretsmanager")
      policy                  = lookup(secret, "policy", null)
      recovery_window_in_days = lookup(secret, "recovery_window_in_days", var.recovery_window_in_days)
      secret_string           = lookup(secret, "secret_string", null) != null ? lookup(secret, "secret_string") : (lookup(secret, "secret_key_value", null) != null ? jsonencode(lookup(secret, "secret_key_value", {})) : null)
      secret_binary           = lookup(secret, "secret_string", null) == null ? lookup(secret, "secret_binary", null) : null
      tags                    = lookup(secret, "tags", {})
    }
  ]

  rotate_secrets = [
    for secret in var.rotate_secrets : {
      name                     = lookup(secret, "name", null)
      name_prefix              = lookup(secret, "name_prefix", null)
      description              = lookup(secret, "description", null)
      kms_key_id               = lookup(secret, "kms_key_id", "aws/secretsmanager")
      policy                   = lookup(secret, "policy", null)
      recovery_window_in_days  = lookup(secret, "recovery_window_in_days", var.recovery_window_in_days)
      secret_string            = lookup(secret, "secret_string", null) != null ? lookup(secret, "secret_string") : (lookup(secret, "secret_key_value", null) != null ? jsonencode(lookup(secret, "secret_key_value", {})) : null)
      secret_binary            = lookup(secret, "secret_string", null) == null ? lookup(secret, "secret_binary", null) : null
      rotation_lambda_arn      = lookup(secret, "rotation_lambda_arn", null)
      automatically_after_days = lookup(secret, "automatically_after_days", var.automatically_after_days)
      tags                     = lookup(secret, "tags", {})
    }
  ]
}
