variable "env" {
  type        = string
  description = "Environment in which the resource is created."
}

variable "cluster_name" {
  default = null
}

variable "ami_id" {
}

variable "security_groups" {
  type = list(string)
}

variable "root_volume_size" {
  default = 30
}

variable "docker_volume_size" {
  default = 100
}

variable "user_data_docker_auth_key" {
  default = ""
}

variable "user_data_docker_auth_email" {
  default = ""
}

variable "asg_subnets" {
  type = list(string)
}

variable "asg_min_size" {
  default = 0
}

variable "asg_max_size" {
  default = 10
}

variable "asg_desired_capacity" {
  default = 0
}

variable "asg_protect_from_scale_in" {
  type    = bool
  default = false
}

variable "asg_memory_scaling_target" {
  type    = number
  default = 0 # 0=disable auto scaling
}

variable "asg_cpu_scaling_target" {
  type    = number
  default = 0 # 0=disable auto scaling
}

variable "asg_scaling_policy_disable_scale_in" {
  type    = bool
  default = true
}

variable "asg_extra_tags" {
  type = map(string)
}

variable "launch_template" {
  description = "Launch template to use with ASG"
  type        = any
  default = {
    on_demand_base_capacity                  = 0
    on_demand_percentage_above_base_capacity = 50
    spot_allocation_strategy                 = "capacity-optimized"
    override_instance_types                  = ["t3a.large", "m5.large", "m5a.large"]
  }
}

variable "ecs_tags" {
  description = "Common service and env tags"
  type        = map(string)
  default     = {}
}

variable "capacity_provider_name" {
  type    = list(any)
  default = []
}

variable "asg_name" {
  type    = string
  default = null
}

variable "lt_name" {
  type    = string
  default = null
}

variable "cp_managed_termination_protection" {
  description = "Enables or disables container-aware termination of instances in the auto scaling group when scale-in happens. Valid values are `ENABLED` and `DISABLED`"
  type        = string
  default     = "DISABLED"
}

variable "cp_managed_scaling" {
  description = "Managed scaling configuration for the capacity provider ASG"
  default     = {}
}

variable "create_capacity_provider" {
  description = "Create an ECS cluster capacity provider and associated ASG"
  type        = bool
  default     = false
}

variable "default_capacity_provider_strategies" {
  description = "The default capacity provider strategies to be used by the cluster, strategies cannot contain a mix of capacity providers using Auto Scaling groups and Fargate providers"
  type = list(object({
    capacity_provider = string
    weight            = number
    base              = number
  }))
  default = [
    {
      capacity_provider = "stg-cp1-ecs-as1"
      weight            = 1
      base              = 0
    }
  ]
}

variable "container_insights" {
  description = "Enable container insights"
  type        = bool
  default     = false
}

variable "capacity_providers" {
  description = "List of short names for one or more capacity providers to associate with the cluster, Valid values also include `FARGATE` and `FARGATE_SPOT`"
  default     = []
}

variable "team" {
  description = "Team in which resource belongs to"
  type        = string
  default     = "infrastructure"
}

variable "project" {
  description = "Project in which resource belongs to"
  type        = string
  default     = "main"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-1"
}

variable "launch_template_count" {
  description = "Count index for launch template"
  type        = number
  default     = 1
}

variable "capacity_provider_count" {
  description = "Count index for capacity provider"
  type        = number
  default     = 1
}

variable "ecs_asg_count" {
  description = "Count index for autoscaling group"
  type        = number
  default     = 1
}

variable "launch_template_file" {
  type = list(any)
}

variable "volume_type" {
  description = "Volume type for EBS"
  type        = string
  default     = "gp2"
}

variable "enable_delete_on_termination" {
  description = "Volume type for EBS"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Volume type for EBS"
  type        = bool
  default     = true
}

variable "ebs_kms_key" {
  description = "Kms key for EBS encryption"
  type        = string
  default     = "alias/aws/ebs"
}
