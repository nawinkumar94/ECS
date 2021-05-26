locals {
  name = "${var.env}-${var.name}"
}

resource "aws_security_group" "this" {
  name        = local.name
  vpc_id      = var.vpc_id
  description = var.description

  dynamic "egress" {
    for_each = var.egress_rules_list
    content {
      from_port       = lookup(egress.value, "from_port", "")
      to_port         = lookup(egress.value, "to_port", "")
      protocol        = lookup(egress.value, "protocol", "")
      cidr_blocks     = lookup(egress.value, "cidr_blocks", [])
      security_groups = lookup(egress.value, "security_groups", [])
      description     = lookup(egress.value, "description", "")
    }
  }

  dynamic "ingress" {
    for_each = var.ingress_rules_list
    content {
      from_port       = lookup(ingress.value, "from_port", "")
      to_port         = lookup(ingress.value, "to_port", "")
      protocol        = lookup(ingress.value, "protocol", "")
      cidr_blocks     = lookup(ingress.value, "cidr_blocks", [])
      security_groups = lookup(ingress.value, "security_groups", [])
      description     = lookup(ingress.value, "description", "")
    }
  }

  tags = merge({
    Name         = local.name
    env          = var.env
    service_name = var.service_name
  },var.sg_extra_tags)

}
