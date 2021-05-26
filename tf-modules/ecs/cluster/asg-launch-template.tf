data "aws_kms_key" "ebs_kms_key" {
  key_id = var.ebs_kms_key
}

#----- ASG using Launch Template--------
resource "aws_launch_template" "asg_launch_template" {
  count                  = var.launch_template_count
  name_prefix            = local.lt_name
  image_id               = var.ami_id
  vpc_security_group_ids = var.security_groups
  user_data              = base64encode(var.launch_template_file[count.index].rendered)

  iam_instance_profile {
    name = aws_iam_instance_profile.this.name
  }

  monitoring {
    enabled = false
  }

  # Root volume
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.root_volume_size
      volume_type           = var.volume_type
      delete_on_termination = var.enable_delete_on_termination
      encrypted             = var.enable_encryption
      kms_key_id            = data.aws_kms_key.ebs_kms_key.arn
    }
  }

  # Docker volume
  block_device_mappings {
    device_name = "/dev/xvdz"

    ebs {
      volume_size           = var.docker_volume_size
      volume_type           = var.volume_type
      delete_on_termination = var.enable_delete_on_termination
      encrypted             = var.enable_encryption
      kms_key_id            = data.aws_kms_key.ebs_kms_key.arn
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.lt_tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.lt_tags
  }

  tags = local.lt_tags

}


resource "aws_autoscaling_group" "ecs_asg" {
  count       = var.ecs_asg_count
  name_prefix = local.asg_name

  vpc_zone_identifier   = var.asg_subnets
  max_size              = var.asg_max_size
  min_size              = var.asg_min_size
  desired_capacity      = var.asg_desired_capacity
  protect_from_scale_in = var.asg_protect_from_scale_in
  health_check_type     = "EC2"

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = var.launch_template["on_demand_base_capacity"]
      on_demand_percentage_above_base_capacity = var.launch_template["on_demand_percentage_above_base_capacity"]
      spot_allocation_strategy                 = var.launch_template["spot_allocation_strategy"]
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.asg_launch_template[count.index].id
        version            = "$Latest"
      }

      dynamic "override" {
        for_each = var.launch_template["override_instance_types"]
        content {
          instance_type = override.value
        }
      }
    }
  }

  tags = concat(
    [
      {
        "key"                 = "Name"
        "value"               = local.asg_name
        "propagate_at_launch" = true
      },
      {
        key                 = "env"
        value               = var.env
        propagate_at_launch = true
      },
      {
        key                 = "Cluster"
        value               = local.cluster_name
        propagate_at_launch = true
      },
      {
        key                 = "datadog"
        value               = "monitored"
        propagate_at_launch = true
      },
      {
        key                 = "Project"
        value               = var.project
        propagate_at_launch = true
      },
      {
        key                 = "Team"
        value               = var.team
        propagate_at_launch = true
      },
      {
        key                 = "Terraform"
        value               = "true"
        propagate_at_launch = true
      }
    ],
    local.tags_asg_format
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}
