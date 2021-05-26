locals {
  secrets = [
    {
      name                    = "${var.ecs_service_name}-dbsecret-key"
      description             = var.secrets_description
      kms_key_id              = var.kms_key_id[local.workspace]
      recovery_window_in_days = var.recovery_window_in_days
      secret_key_value        = local.db_secret_string
    },
    {
      name                    = "${var.ecs_service_name}-slacktoken-key"
      description             = var.secrets_description
      kms_key_id              = var.kms_key_id[local.workspace]
      recovery_window_in_days = var.recovery_window_in_days
      secret_key_value        = local.slack_token_secret_string
    }
  ]
  db_secret_string = {
    username             = var.db_username
    password             = var.db_password
    engine               = var.db_engine
    host                 = var.db_host[local.workspace]
    port                 = var.db_port
    dbname               = var.db_name
    dbInstanceIdentifier = var.db_instance_identifier[local.workspace]
  }

  slack_token_secret_string = {
    bot = var.slack_token
  }
}

module "secretsmanager" {
  source               = "../tf-modules/secrets_manager"
  secrets              = local.secrets
  team                 = var.team
  service_name         = var.ecs_service_name
  env                  = local.workspace
  secrets_manager_tags = var.tags
}
