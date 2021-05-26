output "cluster_arn" {
  description = "The Cluster ARN"
  value       = module.ecs.cluster_arn
}

output "capacity_provider_arn" {
  description = "The capacity provider ARN"
  value       = module.ecs.capacity_provider_arn
}

output "capacity_provider_name" {
  description = "The name of the capacity provider autoscale group"
  value       = module.ecs.capacity_provider_name
}

output "autoscaling_group_arn" {
  description = "The ARN for the capacity provider autoscaling Group"
  value       = module.ecs.autoscaling_group_arn
}

output "launch_template_arn" {
  description = "The Amazon Resource Name (ARN) of the capacity provider launch template"
  value       = module.ecs.launch_template_arn
}

output "launch_template_id" {
  description = "The ID of the capacity provider launch template"
  value       = module.ecs.launch_template_id
}
