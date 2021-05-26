locals {
  container_image = "${var.container_image}:${var.image_tag}"
  env_vars = [
    {
      name  = "ENV"
      value = local.workspace
    },
    {
      name  = "DEPLOYMENT_ENV"
      value = local.workspace
    }
  ]

  secret_variables = [
    {
      name      = "AWS_ACCESS_KEY_ID"
      valueFrom = "arn:aws:secretsmanager:${var.region[local.workspace]}:${local.account_id}:secret:${var.secret_key[local.workspace]}:AWS_ACCESS_KEY::"
    },
    {
      name      = "AWS_SECRET_ACCESS_KEY"
      valueFrom = "arn:aws:secretsmanager:${var.region[local.workspace]}:${local.account_id}:secret:${var.secret_key[local.workspace]}:AWS_ACCESS_KEY_SECRET::"
    },
    {
      name      = "CMS_AWS_ACCESS_KEY"
      valueFrom = "arn:aws:secretsmanager:${var.region[local.workspace]}:${local.account_id}:secret:${var.secret_key[local.workspace]}:AWS_ACCESS_KEY::"
    },
    {
      name      = "CMS_AWS_ACCESS_KEY_SECRET"
      valueFrom = "arn:aws:secretsmanager:${var.region[local.workspace]}:${local.account_id}:secret:${var.secret_key[local.workspace]}:AWS_ACCESS_KEY_SECRET::"
    },
    {
      name      = "DB_SECRET"
      valueFrom = module.secretsmanager.secret_arns[0]
    },
    {
      name      = "SLACK_TOKEN"
      valueFrom = "${module.secretsmanager.secret_arns[1]}:bot::"
    }
  ]

  capacity_provider_strategies = [
    {
      capacity_provider = var.capacity_provider_strategy[local.workspace]
      weight            = 1
      base              = 0
    }
  ]

  ecs_load_balancers = [
    {
      container_name   = var.container_name
      container_port   = var.container_port
      target_group_arn = module.alb_target_groups.target_group_arns[0]
    }
  ]

}

module "ecs_taskdef" {
  source                       = "../tf-modules/ecs/task_definition"
  depends_on                   = [module.secretsmanager]
  task_definition_name         = var.task_definition_name[local.workspace]
  ecs_task_role                = module.task_role.arn
  ecs_task_execution_role      = module.task_execution_role.arn
  task_network_mode            = var.task_network_mode
  container_name               = var.container_name
  container_image              = local.container_image
  essential                    = var.essential
  env                          = local.workspace
  port_mappings                = var.port_mappings
  healthcheck                  = var.healthcheck
  container_memory_reservation = var.container_memory_reservation[local.workspace]
  container_cpu                = var.container_cpu[local.workspace]
  environment                  = local.env_vars
  secret_variables             = local.secret_variables
  service_name                 = var.ecs_service_name
  ulimits                      = var.ulimits
  task_def_tags                = var.tags
  task_placement_constraints   = var.task_placement_constraints
}

module "ecs_service" {
  source                             = "../tf-modules/ecs/service"
  depends_on                         = [module.ecs_taskdef , module.alb_internal]
  service_name                       = var.ecs_service_name
  task_definition                    = module.ecs_taskdef.ecs_task_definition_version
  env                                = local.workspace
  desired_count                      = var.desired_count[local.workspace]
  cluster_name                       = var.cluster_name[local.workspace]
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent[local.workspace]
  deployment_maximum_percent         = var.deployment_maximum_percent[local.workspace]
  platform_version                   = var.platform_version
  scheduling_strategy                = var.scheduling_strategy
  capacity_provider_strategies       = local.capacity_provider_strategies
  ordered_placement_strategy         = var.ordered_placement_strategy
  service_placement_constraints      = var.service_placement_constraints
  ecs_load_balancers                 = local.ecs_load_balancers
  service_tags                       = var.tags
}
