output "cluster_arn" {
  description = "The Cluster ARN"
  value       = aws_ecs_cluster.ecs_cluster.arn
}

output "capacity_provider_arn" {
  description = "The capacity provider ARN"
  value       = join(" , ", aws_ecs_capacity_provider.capacity_provider.*.arn)
}

output "capacity_provider_name" {
  description = "The name of the capacity provider autoscale group"
  value       = join(" , ", aws_ecs_capacity_provider.capacity_provider.*.name)
}

output "autoscaling_group_arn" {
  description = "The ARN for the capacity provider autoscaling Group"
  value       = join(" , ", aws_autoscaling_group.ecs_asg.*.arn)
}

output "launch_template_arn" {
  description = "The Amazon Resource Name (ARN) of the capacity provider launch template"
  value       = join(" , ", aws_launch_template.asg_launch_template.*.arn)
}

output "launch_template_id" {
  description = "The ID of the capacity provider launch template"
  value       = join(" , ", aws_launch_template.asg_launch_template.*.id)
}
