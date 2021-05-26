variable "task_definition_name" {
  type        = map(string)
  description = "The name of the container. Up to 255 characters ([a-z], [A-Z], [0-9], -, _ allowed)"
  default = {
    stg = "stg-nginx-service-task"
    uat = "uat-nginx-service-task"
    prd = "prd-nginx-service-task"
  }
}

variable "container_name" {
  type        = string
  description = "The name of the container. Up to 255 characters ([a-z], [A-Z], [0-9], -, _ allowed)"
  default     = "nginx-service"
}

variable "container_image" {
  type        = string
  description = "The image used to start the container. Images in the Docker Hub registry available by default"
  default     = "nginx:latest"
}

variable "image_tag" {
  type        = string
  description = "Tag for the docker image."
}

variable "container_memory_reservation" {
  type        = map(string)
  description = "The amount of memory (in MiB) to reserve for the container. If container needs to exceed this threshold, it can do so up to the set container_memory hard limit"
  default = {
    stg = 500
    uat = 500
    prd = 500
  }
}

variable "port_mappings" {
  type = list(object({
    containerPort = number
    hostPort      = number
    protocol      = string
  }))
  description = "The port mappings to configure for the container. This is a list of maps. Each map should contain \"containerPort\", \"hostPort\", and \"protocol\", where \"protocol\" is one of \"tcp\" or \"udp\". If using containers in a task with the awsvpc or host network mode, the hostPort can either be left blank or set to the same value as the containerPort"
  default = [
    {
      containerPort = 8080
      hostPort      = 8080
      protocol      = "tcp"
    },
    {
      containerPort = 8090
      hostPort      = 8090
      protocol      = "tcp"
    }
  ]
}

variable "ulimits" {
  type = list(object({
    name      = string
    hardLimit = number
    softLimit = number
  }))
  description = "The port mappings to configure for the container. This is a list of maps. Each map should contain \"containerPort\", \"hostPort\", and \"protocol\", where \"protocol\" is one of \"tcp\" or \"udp\". If using containers in a task with the awsvpc or host network mode, the hostPort can either be left blank or set to the same value as the containerPort"
  default     = {
    name      = "nofile"
    hardLimit = 100000
    softLimit = 100000
  }
}

variable "healthcheck" {
  type = object({
    command     = list(string)
    retries     = number
    timeout     = number
    interval    = number
    startPeriod = number
  })
  description = "A map containing command (string), timeout, interval (duration in seconds), retries (1-10, number of times to retry before marking container unhealthy), and startPeriod (0-300, optional grace period to wait, in seconds, before failed healthchecks count toward retries)"
  default = {
    command     = ["CMD-SHELL", "wget -qO- --timeout=5 --tries=1 localhost:8090/healthcheck || exit 1"]
    retries     = 3
    timeout     = 5
    interval    = 30
    startPeriod = 30
  }
}

variable "container_cpu" {
  type        = map(string)
  description = "The number of cpu units to reserve for the container. This is optional for tasks using Fargate launch type and the total amount of container_cpu of all containers in a task will need to be lower than the task-level cpu value"
  default = {
    stg = 30
    uat = 30
    prd = 30
  }
}

variable "essential" {
  type        = bool
  description = "Determines whether all other containers in a task are stopped, if this container fails or stops for any reason. Due to how Terraform type casts booleans in json it is required to double quote this value"
  default     = true
}

variable "task_network_mode" {
  description = "Docker networking mode"
  default     = "bridge"
}

variable "task_placement_constraints" {
  type = list(object({
    type       = string
    expression = string
  }))
  description = "A set of placement constraints rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10. See `placement_constraints` docs https://www.terraform.io/docs/providers/aws/r/ecs_task_definition.html#placement-constraints-arguments"
  default     = []
}

variable "region" {
  description = "AWS Region"
  type        = map(string)
  default = {
    stg = "us-east-1"
    uat = "us-east-1"
    prd = "us-east-1"
  }
}

variable "account_role" {
  description = "ARN of the Role which Needs to be Assumed from Target AWS Account. TFC Workspace Variable."
  type        = string
}

variable "allowed_account_ids" {
  description = "Allowed AWS accounts for the Given Workspace. TFC Workspace Variable"
  type        = list(any)
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default = {
    Terraform = true
  }
}

variable "ecs_service_name" {
  type        = string
  description = "Name of the Service"
  default     = "nginx-service"
}

variable "deployment_minimum_healthy_percent" {
  type        = map(any)
  description = "The lower limit of the number of running tasks that must remain running and healthy in a service during a deployment."
  default = {
    stg = 50
    uat = 50
    prd = 50
  }
}

variable "deployment_maximum_percent" {
  type        = map(any)
  description = "The upper limit of the number of running tasks that can be running in a service during a deployment."
  default = {
    stg = 100
    uat = 100
    prd = 200
  }
}

variable "health_check_grace_period_seconds" {
  type        = number
  description = "Seconds to ignore failing load balancer health checks"
  default     = 15
}

variable "desired_count" {
  type        = map(any)
  description = "The number of instances of the task definition to place and keep running."
  default = {
    stg = 2
    uat = 2
    prd = 2
  }
}

variable "cluster_name" {
  type        = map(string)
  description = "Name of the ECS Cluster"
  default = {
    stg = "stg-ecs-us1"
    uat = "uat-ecs-us1"
    prd = "prd-ecs-us1"
  }
}

variable "ordered_placement_strategy" {
  type = list(object({
    type  = string
    field = string
  }))
  description = "Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. The maximum number of ordered_placement_strategy blocks is 5. See `ordered_placement_strategy` docs https://www.terraform.io/docs/providers/aws/r/ecs_service.html#ordered_placement_strategy-1"
  default = [
    {
      type  = "spread"
      field = "instanceId"
    },
    {
      type  = "spread"
      field = "attribute:ecs.availability-zone"
    }

  ]
}

variable "service_placement_constraints" {
  type = list(object({
    type       = string
    expression = string
  }))
  description = "The rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10. See `placement_constraints` docs https://www.terraform.io/docs/providers/aws/r/ecs_service.html#placement_constraints-1"
  default     = []
}

variable "platform_version" {
  type        = string
  description = "The platform version on which to run your service. Only applicable for launch_type set to FARGATE. More information about Fargate platform versions can be found in the AWS ECS User Guide."
  default     = "LATEST"
}

variable "scheduling_strategy" {
  type        = string
  description = "The scheduling strategy to use for the service. The valid values are REPLICA and DAEMON. Note that Fargate tasks do not support the DAEMON scheduling strategy."
  default     = "REPLICA"
}

variable "role_description" {
  type        = string
  description = "Description for execution role"
  default     = "Task Execution role for ecs"
}

variable "iam_role_path" {
  type        = string
  description = "Path for IAM Role"
  default     = "/"
}

variable "create_instance_profile" {
  type        = bool
  description = "Whether to create the instance profile or not"
  default     = false

}

variable "external_id" {
  description = "Common external identifier to use when assuming the target accounts role. Check 1Password for externa_id"
  type        = string
}

variable "secret_key" {
  description = "Secret key from secretsmanager"
  type        = map(string)
  default = {
    stg = "aws-access-key-secret-sdsdsd"
    uat = "aws-access-key-secret-fgfgfg"
  }
}

variable "capacity_provider_strategy" {
  description = "capacity provider strategy"
  type        = map(string)
  default = {
    stg = "stg-cp1-ecs-us1"
    uat = "uat-cp1-ecs-us1"
    prd = "prd-cp1-ecs-us1"
  }
}

variable "kms_key_id" {
  description = "Kms key for secrets manager"
  type        = map(string)
  default = {
    stg = "alias/stg-kms-us1-sm-key"
    uat = "alias/uat-kms-us1-sm-key"
    prd = "alias/prd-kms-us1-sm-key"
  }
}

variable "recovery_window_in_days" {
  description = "Specifies the number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days."
  type        = number
  default     = 14
}

variable "secrets_description" {
  description = "Description for secrets in secret manager"
  type        = string
  default     = "Secret for workflow-service"
}

variable "team" {
  description = "Team in which resource belongs to"
  type        = string
  default     = "devops"
}

variable "db_username" {
  description = "DB Username"
  type        = string
  default     = "db_owner"
}

variable "db_password" {
  description = "DB Password"
  type        = string
}

variable "db_name" {
  description = "DB Name"
  type        = string
  default     = "main_db"
}

variable "db_engine" {
  description = "DB Engine"
  type        = string
  default     = "postgres"
}

variable "db_host" {
  description = "DB Host"
  type        = map(string)
  default = {
    stg = "stg-main.useast.sg"
    uat = "uat-main.useast.sg"
    prd = "prd-main.useast.sg"
  }
}

variable "db_port" {
  description = "DB Port"
  type        = string
  default     = "5432"
}

variable "db_instance_identifier" {
  description = "DB Instance Identifier"
  type        = map(string)
  default = {
    stg = "main-stg"
    uat = "main-uat"
    prd = "main-prod"
  }
}

variable "slack_token" {
  description = "Slack Token"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for loadbalancer and target groups"
  type        = map(string)
  default = {
    stg = "vpc-2c3ad751"
    uat = "vpc-2c3ad752"
    prd = "vpc-2c3ad753"
  }
}

variable "lb_type" {
  description = "Set to use application or network loadbalancer"
  type        = string
  default     = "application"
}

variable "lb_name" {
  description = "Name for the application loadbalancer"
  type        = string
  default     = "ecs-nginx-service-int"
}

variable "access_logs_bucket" {
  description = "S3 bucket to put ALB access logs"
  type        = string
  default     = "main-logs-elb-access"
}

variable "container_port" {
  description = "Container port for target groups."
  type        = string
  default     = "8090"
}

variable "access_logs_enable" {
  description = "To enable access logs or not"
  type = map(any)
  default = {
    stg = false
    uat = false
    prd = true
  }
}

variable "lb_tags" {
  description = "Tags for load_balancer and target_group."
  type = map(string)
  default = {
    Project = "ecs-nginx-service"
    Team = "devops"
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
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      cidr_blocks     = ["49.37.211.236/32"]
      description     = "Access to Http port"
      security_groups = []
    },
    {
      from_port       = 443
      to_port         = 443
      protocol        = "tcp"
      cidr_blocks     = ["49.37.211.236/32"]
      description     = "Access to Https port"
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

variable "domain_name" {
  description = "Domain name for acm"
  type        = string
}

variable "certificate_status" {
  description = "ACM certificate status"
  type        = list(string)
  default     = ["ISSUED"]
}

variable "certificate_types" {
  description = "ACM certificate status"
  type        = list(string)
  default     = ["AMAZON_ISSUED"]
}
