resource "aws_lb_listener" "http" {
  count             = length(var.http_tcp_listeners)
  load_balancer_arn = var.load_balancer_arn
  port              = var.http_tcp_listeners[count.index]["port"]
  protocol          = var.http_tcp_listeners[count.index]["protocol"]

  dynamic "default_action" {
    for_each = lookup(var.http_tcp_listeners[count.index],"default_action_redirect_https", false) ? [1] : []
    content {
      type = "redirect"

      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  dynamic "default_action" {
    for_each = lookup(var.http_tcp_listeners[count.index],"default_action_redirect_https", false) ? [] : [1]
    content {
      type             = "forward"
      target_group_arn = lookup(var.http_tcp_listeners[count.index],"default_action_forward_target_groups_arn",null)
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
