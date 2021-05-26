resource "aws_lb_target_group_attachment" "this" {
  count             = length(var.target_group_attachment)
  target_group_arn  = lookup(var.target_group_attachment[count.index], "target_group_arn", null)
  target_id         = lookup(var.target_group_attachment[count.index], "target_id", null)
  port              = lookup(var.target_group_attachment[count.index], "port", null)
  availability_zone = lookup(var.target_group_attachment[count.index], "availability_zone", null)
}
