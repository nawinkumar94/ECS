variable "env" {
  type        = string
  description = "Environment, be either stg/uat/prd"
}

variable "service_name" {
  type        = string
  description = "Application or service name using the target group"
}

variable "target_groups" {
  type        = list
  description = "List of [] target groups configuration block"
  # Example:
  # [{
  #   name     = "ecs-service-targetgroup"
  #   port     = 80
  #   protocol = "HTTP"
  #   vpc_id   = vpc-8011128
  #
  #   health_check = {
  #     enabled             = true
  #     interval            = 30
  #     path                = "/status"
  #     port                = 8001
  #     protocol            = "HTTP"
  #     timeout             = 5
  #     healthy_threshold   = 2
  #     unhealthy_threshold = 2
  #     matcher             = "200"
  #   }
  # }]
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
