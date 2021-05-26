resource "aws_secretsmanager_secret" "secretsmanager_secret" {
  count                   = length(local.secrets)
  name                    = lookup(element(local.secrets, count.index), "name")
  name_prefix             = lookup(element(local.secrets, count.index), "name_prefix")
  description             = lookup(element(local.secrets, count.index), "description")
  kms_key_id              = lookup(element(local.secrets, count.index), "kms_key_id")
  policy                  = lookup(element(local.secrets, count.index), "policy")
  recovery_window_in_days = lookup(element(local.secrets, count.index), "recovery_window_in_days")
  tags                    = merge({ "Name" = lookup(element(local.secrets, count.index), "name"), "Project" = var.project, "Team" = var.team, "env" = var.env, "service_name" = var.service_name }, var.secrets_manager_tags)
}

resource "aws_secretsmanager_secret_version" "secretsmanager_secret_versionv" {
  count         = var.unmanaged ? 0 : length(local.secrets)
  secret_id     = aws_secretsmanager_secret.secretsmanager_secret.*.id[count.index]
  secret_string = lookup(element(local.secrets, count.index), "secret_string")
  secret_binary = lookup(element(local.secrets, count.index), "secret_binary") != null ? base64encode(lookup(element(local.secrets, count.index), "secret_binary")) : null
  depends_on    = [aws_secretsmanager_secret.secretsmanager_secret]
}

resource "aws_secretsmanager_secret_rotation" "secretsmanager_secret_rotation" {
  count               = length(local.rotate_secrets)
  secret_id           = aws_secretsmanager_secret.secretsmanager_secret.*.id[count.index]
  rotation_lambda_arn = lookup(element(local.rotate_secrets, count.index), "rotation_lambda_arn")

  rotation_rules {
    automatically_after_days = lookup(element(local.rotate_secrets, count.index), "automatically_after_days")
  }
}
