variable "load_balancer_arn" {
  description = "ARN of the load balancer to which the listener will be attached to"
  type        = string
}

variable "http_tcp_listeners" {
  description = "List of listeners [{}], each block required values are port, protocol, default_action_redirect_https true or false, if false please provide default_action_forward_target_groups_arn"
  type        = list
  default     = []
}