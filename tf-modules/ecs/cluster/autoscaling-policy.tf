#----- Autoscaling Policy --------
resource "aws_autoscaling_policy" "MemoryReservation" {
  # Only create when asg_memory_scaling_target is set and capacity provider is false
  count = var.create_capacity_provider == false && var.asg_memory_scaling_target > 0 ? var.ecs_asg_count : 0

  name                   = "${local.asg_name}-MemRes"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg[count.index].name

  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 300

  target_tracking_configuration {
    customized_metric_specification {
      metric_dimension {
        name  = "ClusterName"
        value = local.cluster_name
      }

      metric_name = "MemoryReservation"
      namespace   = "AWS/ECS"
      statistic   = "Average"
      unit        = "Percent"
    }

    target_value     = var.asg_memory_scaling_target
    disable_scale_in = var.asg_scaling_policy_disable_scale_in
  }
}

resource "aws_autoscaling_policy" "CPUReservation" {
  # Only create when asg_cpu_scaling_target is set and capacity provider is false.
  count = var.create_capacity_provider == false && var.asg_cpu_scaling_target > 0 ? var.ecs_asg_count : 0

  name                   = "${local.asg_name}-CPURes"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg[count.index].name

  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 300

  target_tracking_configuration {
    customized_metric_specification {
      metric_dimension {
        name  = "ClusterName"
        value = local.cluster_name
      }

      metric_name = "CPUReservation"
      namespace   = "AWS/ECS"
      statistic   = "Average"
      unit        = "Percent"
    }

    target_value     = var.asg_cpu_scaling_target
    disable_scale_in = var.asg_scaling_policy_disable_scale_in
  }
}

resource "aws_autoscaling_policy" "MemoryUtilization" {
  # Only create when asg_memory_scaling_target is set
  depends_on = [aws_ecs_cluster.ecs_cluster]
  count      = var.asg_memory_scaling_target > 0 ? var.ecs_asg_count : 0

  name                   = "${local.asg_name}-Mem-Utlization"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg[count.index].name

  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 300

  target_tracking_configuration {
    customized_metric_specification {
      metric_dimension {
        name  = "ClusterName"
        value = local.cluster_name
      }

      metric_name = "MemoryUtilization"
      namespace   = "AWS/ECS"
      statistic   = "Average"
      unit        = "Percent"
    }

    target_value     = var.asg_memory_scaling_target
    disable_scale_in = var.asg_scaling_policy_disable_scale_in
  }
}

resource "aws_autoscaling_policy" "CPUUtilization" {
  # Only create when asg_cpu_scaling_target is set
  depends_on = [aws_ecs_cluster.ecs_cluster]
  count      = var.asg_cpu_scaling_target > 0 ? var.ecs_asg_count : 0

  name                   = "${local.asg_name}-CPU-Utilization"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg[count.index].name

  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 300

  target_tracking_configuration {

    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value     = var.asg_cpu_scaling_target
    disable_scale_in = var.asg_scaling_policy_disable_scale_in
  }
}
