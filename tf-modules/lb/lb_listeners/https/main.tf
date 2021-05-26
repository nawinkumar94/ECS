resource "aws_lb_listener" "https" {
  count             = length(var.https_tcp_listeners)
  load_balancer_arn = var.load_balancer_arn
  port              = var.https_tcp_listeners[count.index]["port"]
  protocol          = var.https_tcp_listeners[count.index]["protocol"]
  ssl_policy        = var.https_tcp_listeners[count.index]["ssl_policy"]
  certificate_arn   = var.https_tcp_listeners[count.index]["certificate_arn"]

  default_action {
    target_group_arn = var.https_tcp_listeners[count.index]["target_group_arn"]
    type             = "forward"
  }

  lifecycle {
    create_before_destroy = true
  }
}
