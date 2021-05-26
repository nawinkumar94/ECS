variable "load_balancer_arn" {
  description = "ARN of the load balancer to which the listener will be attached to"
  type        = string
}

variable "https_tcp_listeners" {
  description = "A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08), target_group_index (defaults to 0)"
  type = list(object({
    port             = number
    protocol         = string
    ssl_policy       = string
    certificate_arn  = string
    target_group_arn = string
  }))
  default = []
}