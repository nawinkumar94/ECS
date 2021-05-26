variable "env" {
  type        = string
  description = "Environment, be either stg/uat/prd"
}

variable "service_name" {
  type        = string
  description = "Service name using the ALB"
}

variable "type" {
  type        = string
  description = "LB type, application or network"
}

variable "name" {
  type = string
}

variable "internal" {
  type    = bool
  default = false
}

variable "subnets" {
  description = "A list of subnets to associate with the load balancer"
  type        = list(string)
}

variable "security_groups" {
  type        = list(string)
  description = "The security groups to attach to the load balancer"
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  type        = number
  default     = 60
}

variable "enable_cross_zone_load_balancing" {
  description = "Indicates whether cross zone load balancing should be enabled in application load balancers."
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Indicates whether HTTP/2 is enabled in application load balancers."
  type        = bool
  default     = true
}

variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack."
  type        = string
  default     = "ipv4"
}

variable "access_logs" {
  type        = any
  description = "Access logs config block"
  default     = {}
}

variable "target_groups" {
  type        = any
  description = "List [] of target groups configuration block."
  default     = []
}

variable "aws_lb_listeners" {
  type        = any
  description = "List [] of aws_lb_listeners configuration block"
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

