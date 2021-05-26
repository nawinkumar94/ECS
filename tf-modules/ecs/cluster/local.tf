locals {
  cluster_name    = var.cluster_name != null ? var.cluster_name : "${var.env}-ecs-as1"
  asg_name        = var.asg_name != null ? var.asg_name : "${var.env}-asg-ecs-as1"
  lt_name         = var.lt_name != null ? var.lt_name : "${var.env}-lt-asg-ecs-as1"
  tags_asg_format = null_resource.tags_as_list_of_maps.*.triggers
  lt_tags = merge(
    { "Name" = format("%s", local.lt_name), "env" = var.env, "Team" = var.team, "Project" = var.project },
  var.ecs_tags)
}

resource "null_resource" "tags_as_list_of_maps" {
  count = length(keys(var.asg_extra_tags))

  triggers = {
    "key"                 = keys(var.asg_extra_tags)[count.index]
    "value"               = values(var.asg_extra_tags)[count.index]
    "propagate_at_launch" = "true"
  }
}
