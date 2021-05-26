resource "aws_ecs_cluster" "ecs_cluster" {
  depends_on         = [aws_ecs_capacity_provider.capacity_provider]
  name               = local.cluster_name
  capacity_providers = var.create_capacity_provider ? concat(var.capacity_provider_name, var.capacity_providers) : var.capacity_providers

  setting {
    name  = "containerInsights"
    value = var.container_insights ? "enabled" : "disabled"
  }

  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategies
    iterator = cp

    content {
      capacity_provider = lookup(cp.value, "capacity_provider", null)
      weight            = lookup(cp.value, "weight", null)
      base              = lookup(cp.value, "base", null)
    }
  }

  tags = merge(
    { "Name" = format("%s", local.cluster_name), "env" = var.env, "Team" = var.team, "Project" = var.project },
    var.ecs_tags
  )
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_ecs_capacity_provider" "capacity_provider" {
  count      = var.create_capacity_provider ? var.capacity_provider_count : 0
  depends_on = [aws_autoscaling_group.ecs_asg]
  name       = var.capacity_provider_name[count.index]

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg[count.index].arn
    managed_termination_protection = var.cp_managed_termination_protection

    dynamic "managed_scaling" {
      for_each = length(var.cp_managed_scaling) != 0 ? [var.cp_managed_scaling] : []

      content {
        maximum_scaling_step_size = lookup(managed_scaling.value, "maximum_scaling_step_size", null)
        minimum_scaling_step_size = lookup(managed_scaling.value, "minimum_scaling_step_size", null)
        status                    = lookup(managed_scaling.value, "status", null)
        target_capacity           = lookup(managed_scaling.value, "target_capacity", null)
      }
    }
  }

  tags = merge(
    { "Name" = format("%s", var.capacity_provider_name[count.index]), "env" = var.env, "Team" = var.team, "Project" = var.project },
    var.ecs_tags
  )
}
