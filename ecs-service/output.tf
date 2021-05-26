output "ecs_task_definition_arn" {
  description = "Task definitions arn for ECS"
  value       = module.ecs_taskdef.ecs_task_definition_arn
}

output "ecs_task_definition_family" {
  description = "Task definitions family for ECS"
  value       = module.ecs_taskdef.ecs_task_definition_family
}

output "ecs_task_definition_version" {
  description = "Task definitions latest for ECS"
  value       = module.ecs_taskdef.ecs_task_definition_version
}

output "container_definition_json" {
  description = "JSON encoded container definitions for use with other terraform resources such as aws_ecs_task_definition"
  value       = module.ecs_taskdef.container_definition_json
}

output "secret_ids" {
  description = "Secret id list"
  value       = module.secretsmanager.secret_ids
}

output "secret_arns" {
  description = "Secret arn list"
  value       = module.secretsmanager.secret_arns
}
