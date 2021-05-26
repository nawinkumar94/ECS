variable "cluster_name" {
  description = "Override default cluster name"
  type        = map(string)
  default = {
    stg = "stg-ecs-us1"
    uat = "uat-ecs-us1"
    prd = "prd-ecs-us1"
  }
}

variable "capacity_provider_name" {
  description = "Override default capacity_provider_name"
  type        = map(list(string))
  default = {
    stg = ["stg-cp-ecs-us1"]
    uat = ["uat-cp-ecs-us1"]
    prd = ["prd-cp-ecs-us1"]
  }
}

variable "asg_name" {
  description = "Override default autoscaling_group_name"
  type        = map(string)
  default = {
    stg = "stg-asg-ecs-us1"
    uat = "uat-asg-ecs-us1"
    prd = "prd-asg-ecs-us1"
  }
}

variable "lt_name" {
  description = "Override default launch_configuration_name"
  type        = map(string)
  default = {
    stg = "stg-lt-asg-ecs-us1"
    uat = "uat-lt-asg-ecs-us1"
    prd = "prd-lt-asg-ecs-us1"
  }
}

variable "vpc_subnet_tag_tier" {
  description = "Choosing subnets using tag with key tier, value is public/private"
  type        = map(string)
  default = {
    stg = "private"
    uat = "private"
    prd = "private"
  }
}

variable "user_data_docker_auth_email" {
  description = "Docker Auth email, inject during init script via user data"
}

variable "user_data_docker_auth_key" {
  description = "Docker Auth key, inject during init script via user data"
}

variable "root_volume_size" {
  description = "EC2 instance root volume size"
  type        = map(string)
  default = {
    stg = 30
    uat = 30
    prd = 30
  }
}

variable "docker_volume_size" {
  description = "EC2 instance docker volume size"
  type        = map(string)
  default = {
    stg = 100
    uat = 100
    prd = 100
  }
}

variable "asg_min_size" {
  description = "Minimum ASG size"
  type        = map(string)
  default = {
    stg = 0
    uat = 0
    prd = 5
  }
}

variable "asg_max_size" {
  description = "Minimum ASG size"
  type        = map(string)
  default = {
    stg = 5
    uat = 5
    prd = 10
  }
}

variable "asg_desired_capacity" {
  description = "Desired ASG size"
  type        = map(string)
  default = {
    stg = 0
    uat = 0
    prd = 6
  }
}

variable "asg_memory_scaling_target" {
  description = "Target tracking in % for Memory in ASG, set to 0 to disable scaling policy"
  type        = map(string)
  default = {
    stg = 90
    uat = 80
    prd = 70
  }
}

variable "asg_cpu_scaling_target" {
  description = "Target tracking in % for CPU in ASG, set to 0 to disable scaling policy"
  type        = map(string)
  default = {
    stg = 90
    uat = 80
    prd = 70
  }
}

variable "asg_protect_from_scale_in" {
  description = "Protect instance from terminated when scale in"
  type        = map(string)
  default = {
    stg = false
    uat = false
    prd = true
  }
}

variable "lt_on_demand_base_capacity" {
  description = "Launch template configuration - demand_base_capacity"
  type        = map(number)
  default = {
    stg = 0
    uat = 0
    prd = 0
  }
}

variable "lt_on_demand_percentage_above_base_capacity" {
  description = "Launch template configuration - on_demand_percentage_above_base_capacity"
  type        = map(number)
  default = {
    stg = 20
    uat = 50
    prd = 100
  }
}

variable "lt_spot_allocation_strategy" {
  description = "Launch template configuration - spot_allocation_strategy"
  type        = map(string)
  default = {
    stg = "capacity-optimized"
    uat = "capacity-optimized"
    prd = "capacity-optimized"
  }
}

variable "lt_override_instance_types" {
  description = "Launch template configuration - override_instance_types"
  type        = map(list(string))
  default = {
    stg = ["m5.large", "m5a.large"]
    uat = ["m5a.large", "m5.xlarge", "m5a.xlarge"]
    prd = ["m5a.large", "m5.xlarge", "m5a.xlarge"]
  }
}

variable "ecs_tags" {
  type = map(string)
  default = {
    Terraform    = true
    service_name = "ecs"
  }
}

variable "cp_managed_scaling" {
  description = "Managed scaling configuration for the capacity provider ASG"
  type        = map(map(string))
  default = {
    stg = {
      maximum_scaling_step_size = 3
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
    uat = {
      maximum_scaling_step_size = 3
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
    prd = {
      maximum_scaling_step_size = 5
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

variable "create_capacity_provider" {
  description = "Create an ECS cluster capacity provider and associated ASG"
  type        = bool
  default     = true
}

variable "cp_managed_termination_protection" {
  description = "Enables or disables container-aware termination of instances in the auto scaling group when scale-in happens. Valid values are `ENABLED` and `DISABLED`"
  type        = map(string)
  default = {
    stg = "DISABLED"
    uat = "DISABLED"
    prd = "ENABLED"
  }
}

variable "container_insights" {
  description = "Enable container insights"
  type        = map(string)
  default = {
    stg = false
    uat = false
    prd = false
  }
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
      capacity_provider = "stg-cp1-ecs-us1"
      weight            = 1
      base              = 0
    }
  ]
}

variable "capacity_providers" {
  description = "List of short names for one or more capacity providers to associate with the cluster, Valid values also include `FARGATE` and `FARGATE_SPOT`"
  type        = list(string)
  default     = []
}

variable "account_role" {
  description = "ARN of the Role which Needs to be Assumed from Target AWS Account. TFC Workspace Variable."
  type        = string
}

variable "allowed_account_ids" {
  description = "Allowed AWS accounts for the Given Workspace. TFC Workspace Variable"
  type        = list(any)
}

variable "region" {
  description = "AWS Region"
  type        = map(string)
  default = {
    stg = "us-east-1"
    uat = "us-east-11"
    prd = "us-east-1"
  }
}

variable "launch_template_count" {
  description = "Count index for launch template"
  type        = map(string)
  default = {
    stg = 1
    uat = 1
    prd = 2
  }
}

variable "capacity_provider_count" {
  description = "Count index for capacity provider"
  type        = map(string)
  default = {
    stg = 1
    uat = 1
    prd = 2
  }
}

variable "ecs_asg_count" {
  description = "Count index for autoscaling group"
  type        = map(string)
  default = {
    stg = 1
    uat = 1
    prd = 2
  }
}

variable "ecs_instance_attributes" {
  description = "Custom attributes for ecs instances"
  type        = map(list(string))
  default = {
    stg = ["", "{\"main.consul-version\":\"1.7.4\"}"]
    uat = []
    prd = []
  }
}

variable "ebs_kms_key" {
  description = "Kms key for EBS encryption"
  type        = map(string)
  default = {
    stg = "alias/stg-kms-us1-ebs-key"
    uat = "alias/aws/ebs"
    prd = "alias/aws/ebs"
  }
}

variable "ami_owner" {
  description = "Owner of the ami to be launched in launch templates"
  type        = string
}

variable "ami_id" {
  description = "Ami id for the ecs cluster"
  type        = string
}

variable "service_name" {
  description = "Override default cluster name"
  type        = string
  default     = "ecs"
}

variable "security_group_name" {
  description = "Name of RDS instance security group"
  type        = string
  default     = "sg-us1-ecs"
}

variable "sg_extra_tags" {
  description = "The name of the log group."
  type        = map(string)
  default = {
    Terraform    = true
    Team         = "devops"
    Project      = "main"
    service_name = "ecs"
  }
}

variable "sg_ingress_rules_list" {
  description = "Security Group Ingress rules list"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = list(string)
    security_groups = list(string)
    description     = string
  }))
  default = [
    {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      cidr_blocks     = ["49.37.211.236/32"]
      description     = "ssh"
      security_groups = []
    },
    {
      from_port       = 0
      to_port         = 0
      protocol        = -1
      cidr_blocks     = ["49.37.211.236/32"]
      description     = "Access to all traffic in main vpc"
      security_groups = []
    }
  ]
}

variable "sg_egress_rules_list" {
  description = "Security Group Ingress rules list"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = list(string)
    security_groups = list(string)
    description     = string
  }))
  default = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
      description     = "Oubound rules allow all traffic"
      security_groups = []
    }
  ]
}

variable "external_id" {
  description = "Common external identifier to use when assuming the target accounts role. Check 1Password for externa_id"
  type        = string
}

variable "asg_scaling_policy_disable_scale_in" {
  type        = map(bool)
  description = "To determine whether scalein need to be enabled in ASG or not."
  default = {
    stg = false
    uat = false
    prd = true
  }
}
