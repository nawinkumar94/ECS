data "aws_iam_policy_document" "ecs_ec2_cloudwatch_autodiscover_policy" {

  statement {
    sid = "EcsEc2CloudwatchAutodiscoverPolicy"

    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "ec2:DescribeTags",
      "ec2:CreateTags",
      "ec2:DescribeInstances"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "this" {
  name = "${local.cluster_name}-ecs-instance-role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "this" {
  name = "${local.cluster_name}-ecs-instance-profile"
  role = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  role       = aws_iam_role.this.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_agent_role" {
  role       = aws_iam_role.this.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_ssm_instance_role" {
  role       = aws_iam_role.this.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
