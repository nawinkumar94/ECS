variable "target_group_attachment" {
  description = "List of [] target groups attachment"
  type        = list(any)
  # Example:
  # [{
  #   target_group_arn  = "arn:aws:elasticloadbalancing:us-east-1:884362627737:targetgroup/ecs-service-targetgroup-int/3adcae4bb1742de6"
  #   target_id         = "i-08743e1b7e63a7744"
  #   port              = 80
  #   availability_zone = "us-east-1a"
  # }]
}
