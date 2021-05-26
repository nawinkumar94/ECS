locals {
  name = "${var.env}-${var.name}"
}

#-----------ALB---------------------
resource "aws_lb" "this" {
  load_balancer_type               = var.type
  name                             = local.name
  internal                         = var.internal
  security_groups                  = var.security_groups
  subnets                          = var.subnets
  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  enable_http2                     = var.enable_http2
  ip_address_type                  = var.ip_address_type

  tags = merge(
    var.tags,
    {
      env          = var.env
      service_name = var.service_name
      tier         = var.internal ? "internal" : "external"
      Name         = local.name
    }
  )

  dynamic "access_logs" {
    for_each = length(keys(var.access_logs)) == 0 ? [] : [var.access_logs]

    content {
      enabled = lookup(access_logs.value, "enabled", null)
      bucket  = lookup(access_logs.value, "bucket", null)
      prefix  = lookup(access_logs.value, "prefix", null)
    }
  }

}




