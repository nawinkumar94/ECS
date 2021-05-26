#----- VPC and Subnets--------
data "aws_vpc" "selected" {
  tags = {
    env = local.workspace
  }
}

data "aws_subnet_ids" "selected" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    tier = var.vpc_subnet_tag_tier[local.workspace]
  }
}

#----- AMI --------
data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["main_ami_amz_ecs*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = [var.ami_owner]
}

data "template_file" "user_data" {
  count    = var.launch_template_count[local.workspace]
  template = file("${path.module}/templates/user_data.sh")

  vars = {
    env                     = local.workspace
    cluster_name            = var.cluster_name[local.workspace]
    docker_auth_key         = var.user_data_docker_auth_key
    docker_auth_email       = var.user_data_docker_auth_email
    ecs_instance_attributes = jsonencode(var.ecs_instance_attributes[local.workspace][count.index])
  }
}

#----- ECS  --------
module "ecs" {
  source                               = "../tf-modules/ecs/cluster"
  env                                  = local.workspace
  cluster_name                         = var.cluster_name[local.workspace]
  capacity_provider_name               = var.capacity_provider_name[local.workspace]
  cp_managed_scaling                   = var.cp_managed_scaling[local.workspace]
  ecs_tags                             = var.ecs_tags
  cp_managed_termination_protection    = var.cp_managed_termination_protection[local.workspace]
  container_insights                   = var.container_insights[local.workspace]
  default_capacity_provider_strategies = var.default_capacity_provider_strategies
  create_capacity_provider             = var.create_capacity_provider
  capacity_providers                   = var.capacity_providers
  ami_id                               = var.ami_id == "" ? data.aws_ami.ecs.id : var.ami_id
  security_groups                      = [module.ecs-sg.id]
  user_data_docker_auth_key            = var.user_data_docker_auth_key
  user_data_docker_auth_email          = var.user_data_docker_auth_email
  root_volume_size                     = var.root_volume_size[local.workspace]
  docker_volume_size                   = var.docker_volume_size[local.workspace]
  asg_subnets                          = data.aws_subnet_ids.selected.ids
  asg_min_size                         = var.asg_min_size[local.workspace]
  asg_max_size                         = var.asg_max_size[local.workspace]
  asg_desired_capacity                 = var.asg_desired_capacity[local.workspace]
  asg_memory_scaling_target            = var.asg_memory_scaling_target[local.workspace]
  asg_cpu_scaling_target               = var.asg_cpu_scaling_target[local.workspace]
  asg_protect_from_scale_in            = var.asg_protect_from_scale_in[local.workspace]
  launch_template_count                = var.launch_template_count[local.workspace]
  capacity_provider_count              = var.capacity_provider_count[local.workspace]
  ecs_asg_count                        = var.ecs_asg_count[local.workspace]
  asg_name                             = var.asg_name[local.workspace]
  lt_name                              = var.lt_name[local.workspace]
  asg_scaling_policy_disable_scale_in  = var.asg_scaling_policy_disable_scale_in[local.workspace]
  launch_template_file                 = data.template_file.user_data
  ebs_kms_key                          = var.ebs_kms_key[local.workspace]
  asg_extra_tags                       = {}
  launch_template = {
    on_demand_base_capacity                  = var.lt_on_demand_base_capacity[local.workspace]
    on_demand_percentage_above_base_capacity = var.lt_on_demand_percentage_above_base_capacity[local.workspace]
    spot_allocation_strategy                 = var.lt_spot_allocation_strategy[local.workspace]
    override_instance_types                  = var.lt_override_instance_types[local.workspace]
  }
}

module "ecs-sg" {
  source             = "../tf-modules//aws/security_group"
  env                = local.workspace
  service_name       = "${var.service_name}-${local.workspace}"
  name               = var.security_group_name
  description        = "Security Group for ${var.service_name}-${local.workspace}"
  vpc_id             = data.aws_vpc.selected.id
  ingress_rules_list = var.sg_ingress_rules_list
  egress_rules_list  = var.sg_egress_rules_list
  sg_extra_tags      = var.sg_extra_tags
}
