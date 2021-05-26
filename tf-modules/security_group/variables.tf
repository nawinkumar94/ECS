variable "env" {
  description = "Environment stg/uat/prd"
}

variable "name" {
  description = "Security Group Name"
}

variable "description" {
  description = "Security Group Description"
}

variable "service_name" {
  description = "service_name tag"
}

variable "vpc_id" {
  description = "VPC Id for the subnets"
}

variable "ingress_rules_list" {
  description = "Ingress Rules for the security group"
  type        = list
}

variable "egress_rules_list" {
  description = "Egress Rules for the security group"
  type        = list
}

variable "sg_extra_tags" {
  description = "Additional tags to be added for the security group"
  type        = map(string)
  default     = {}
}
