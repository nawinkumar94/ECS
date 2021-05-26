variable "env" {
  description = "env stg/uat/prd"
  type        = string
}

variable "name" {
  description = "name of the role"
  type        = string
}

variable "service_name" {
  description = "service that using the role"
  type        = string
}

variable "description" {
  description = "description of the role"
  type        = string
}

variable "trusted_principles" {
  description = "ARNs of AWS entities who can assume these roles"
  type = list(object({
    type        = string
    identifiers = list(string)
  }))
  default = []
}

variable "force_detach_policies" {
  description = "force_detach_policies"
  type        = bool
  default     = false
}

variable "path" {
  description = "path to the role"
  type        = string
  default     = ""
}

variable "max_session_duration" {
  description = "max_session_duration of the role"
  type        = number
  default     = null
}

variable "permissions_boundary" {
  description = "permissions_boundary of the role"
  type        = string
  default     = ""
}

variable "create_instance_profile" {
  description = "Whether to create the instance profile"
  type        = bool
}

variable "inline_role_policy_list" {
  type = list(object({
    name   = string
    policy = string
  }))
  default     = []
  description = "List of inline policy for the role"
}

variable "custom_role_policy_arns" {
  type    = list(string)
  default = []
}

variable "extra_tags" {
  type        = map(string)
  description = "extra tags beside name, service_name and env"
  default     = {}
}