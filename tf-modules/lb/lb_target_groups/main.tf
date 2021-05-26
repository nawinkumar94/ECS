#------------Target Group---------------
resource "aws_lb_target_group" "this" {
  count                              = length(var.target_groups)
  name                               = "${var.env}-${lookup(var.target_groups[count.index], "name", null)}"
  vpc_id                             = lookup(var.target_groups[count.index], "vpc_id", null)
  port                               = lookup(var.target_groups[count.index], "port", null)
  protocol                           = lookup(var.target_groups[count.index], "protocol", null)
  target_type                        = lookup(var.target_groups[count.index], "target_type", null)
  deregistration_delay               = lookup(var.target_groups[count.index], "deregistration_delay", null)
  slow_start                         = lookup(var.target_groups[count.index], "slow_start", null)
  proxy_protocol_v2                  = lookup(var.target_groups[count.index], "proxy_protocol_v2", null)
  lambda_multi_value_headers_enabled = lookup(var.target_groups[count.index], "lambda_multi_value_headers_enabled", null)

  dynamic "health_check" {
    for_each = length(keys(lookup(var.target_groups[count.index], "health_check", {}))) == 0 ? [] : [lookup(var.target_groups[count.index], "health_check", {})]

    content {
      enabled             = lookup(health_check.value, "enabled", null)
      interval            = lookup(health_check.value, "interval", null)
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "port", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
      timeout             = lookup(health_check.value, "timeout", null)
      protocol            = lookup(health_check.value, "protocol", null)
      matcher             = lookup(health_check.value, "matcher", null)
    }
  }

  dynamic "stickiness" {
    for_each = length(keys(lookup(var.target_groups[count.index], "stickiness", {}))) == 0 ? [] : [lookup(var.target_groups[count.index], "stickiness", {})]

    content {
      enabled         = lookup(stickiness.value, "enabled", null)
      cookie_duration = lookup(stickiness.value, "cookie_duration", null)
      type            = lookup(stickiness.value, "type", null)
    }
  }

  tags = merge(
    var.tags,
    {
      env          = var.env
      service_name = var.service_name
      Name         = "${var.env}-${lookup(var.target_groups[count.index], "name", null)}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}