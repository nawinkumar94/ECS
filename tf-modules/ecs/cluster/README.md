# Terraform modules to setup ECS cluster with Auto-Scaling Group

This module setup a ECS cluster together with an Auto Scaling Group. Default cluster name is `tf-{var.env}`, this is customizable using variable `cluster_name`

The launch configuration/template includes user data to setup:
- Setup ECS config with Docker Authentication read from input variables
- Create a separate EBS volume for Docker and mount to `/var/lib/docker`
- Set Docker log rotatation rules
- Tag the EC2 instance follow standard, e.g: `prd-ec2-as1-1a-ecs01`
- Contact Deep Security Manager and set the policy to **Base Policy**

For more details, refer to `templates/user_data.sh`.

## Examples
Refer to `examples` folder for completed example.

```
module "ecs" {
  source = "../"

  env = "utils"

  # Launch configuration setups
  lc_ami_id = "ami-0a1a248fd8dcc5b5d"
  lc_instance_type = "t3.large"
  lc_security_groups = ["sg-0e1ca6be76b8d1bf2"]
  lc_user_data_docker_auth_key = "xyzabc123"
  lc_user_data_docker_auth_email = "tech.socmed@gmail.com"

  lc_root_volume_size = 30
  lc_docker_volume_size = 50

  # Auto Scaling Group Setup
  asg_subnets = data.aws_subnet_ids.selected.ids

  asg_min_size = 0
  asg_max_size = 10
  asg_desired_capacity = 1

  asg_extra_tags = {
  }

}
```

## Variables

| Name                        | Description                                                                                     | Type               | Default  |
|-----------------------------|-------------------------------------------------------------------------------------------------|--------------------|----------|
| cluster_name                | Default is `tf-{var.env}`, if set will replace the default value                                | string             | null     |
| env                         | Environment. Will be used to name the cluster as `tf-env`                                       | string             |          |
| ami_id                      | LC/LT AMI ID                                                                                    | string             |          |
| instance_type               | LC/LT instance type                                                                             | string             | t3.large |
| security_groups             | LC/LT security groups                                                                           | list(string)       |          |
| root_volume_size            | LC/LT root volume size                                                                          | string             | 30       |
| docker_volume_size          | LC/LT docker volume size (mount to /var/lib/docker)                                             | string             | 100      |
| user_data_docker_auth_key   | Docker authentication key to inject to ECS config during instance init                          | string             |          |
| user_data_docker_auth_email | Docker authentication email to inject to ECS config during instance init                        | string             |          |
| asg_subnets                 | Auto Scaling Group (ASG) subnets id                                                             | list(string)       |          |
| asg_min_size                | ASG minimum number of instances                                                                 | string             | 0        |
| asg_max_size                | ASG maximum number of instances                                                                 | string             | 10       |
| asg_desired_capacity        | ASG desired capacity                                                                            | string             | 0        |
| asg_memory_scaling_target   | Scaling target for memory (%), default is 0 = disable autoscaling                               |
string             | 0        |
| asg_cpu_scaling_target      | Scaling target for cpu (%), default is 0 = disable auto scaling                                 |
string             | 0        |
| asg_protect_from_scale_in   | Set to true to enable scale in protection                                                       | bool               | false    |
| asg_extra_tags              | Extra tags to add to ASG. Existing tag is: `env=var.env, Cluster=tf-var.env, datadog=monitored` | type = map(string) |          |
| launch_template             | Launch template config in block {}. Check examples for valid keys                               | any                | {}       |
