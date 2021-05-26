locals {
  lb_target_groups = [{
    name        = "ecs-nginx-service-int"
    vpc_id      = data.aws_vpc.selected.id
    port        = var.container_port
    protocol    = "HTTP"
    target_type = "instance"
    health_check = {
      enabled             = true
      interval            = 30
      path                = "/"
      port                = "traffic-port"
      protocol            = "HTTP"
      timeout             = 5
      healthy_threshold   = 5
      unhealthy_threshold = 2
      matcher             = "200"
    }

  }]
}

data "aws_vpc" "selected" {
  tags = {
    env = local.workspace
  }
}

data "aws_subnet_ids" "public_subnet" {
  vpc_id = data.aws_vpc.selected.id
  tags = {
    tier = var.vpc_subnet_tag_tier[local.workspace]
  }
}

data "aws_acm_certificate" "mydomain" {
  domain   = var.domain_name
  statuses = var.certificate_status
  types    = var.certificate_types
}

module "alb_target_groups" {
  source        = "../tf-modules/lb/lb_target_groups"
  env           = local.workspace
  service_name  = var.ecs_service_name
  target_groups = local.lb_target_groups
  tags          = var.lb_tags
}

module "alb_internal" {
  source                     = "../tf-modules/lb/lb"
  depends_on                 = [module.lb-internal-sg]
  env                        = local.workspace
  service_name               = var.ecs_service_name
  type                       = var.lb_type
  name                       = var.lb_name
  internal                   = true
  security_groups            = [module.lb-internal-sg.id]
  subnets                    = data.aws_subnet_ids.public_subnet.ids
  enable_deletion_protection = true
  tags                       = var.lb_tags
  access_logs = {
    bucket  = var.access_logs_bucket
    prefix  = "${local.workspace}-${var.lb_name}"
    enabled = lookup(var.access_logs_enable, local.workspace, false)
  }
}

module "alb_listener_http" {
  source            = "../tf-modules/lb/lb_listeners/http"
  depends_on        = [module.alb_internal]
  load_balancer_arn = module.alb_internal.lb_arn
  http_tcp_listeners = [
    {
      port                          = "80"
      protocol                      = "HTTP"
      default_action_redirect_https = true
    }
  ]
}

module "alb_listener_https" {
  source            = "../tf-modules/lb/lb_listeners/https"
  depends_on        = [module.alb_internal,module.alb_target_groups]
  load_balancer_arn = module.alb_internal.lb_arn
  https_tcp_listeners = [
    {
      port             = "443"
      protocol         = "HTTPS"
      ssl_policy       = "ELBSecurityPolicy-2016-08"
      certificate_arn  = data.aws_acm_certificate.mydomain.arn
      target_group_arn = module.alb_target_groups.target_group_arns[0]
    }
  ]
}

module "lb-internal-sg" {
  source             = "../tf-modules/security_group"
  env                = local.workspace
  service_name       = var.ecs_service_name
  name               = "${var.ecs_service_name}-lb-internal"
  description        = "Security Group for ${var.lb_name}-${local.workspace}"
  vpc_id             = data.aws_vpc.selected.id
  ingress_rules_list = var.sg_ingress_rules_list
  egress_rules_list  = var.sg_egress_rules_list

}
