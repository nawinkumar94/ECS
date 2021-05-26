locals {
  account_id = data.aws_caller_identity.current.account_id
  inline_role_policy_list = [
    {
      name   = "s3-access-policy"
      policy = data.aws_iam_policy_document.s3_access_policy.json
    }
  ]
  inline_execution_role_policy_list = [
    {
      name   = "secretmanager-access-policy"
      policy = data.aws_iam_policy_document.secretmanager_access_policy.json
    },
    {
      name   = "kms-secretmanager-access-policy"
      policy = data.aws_iam_policy_document.kms_secretmanager_access_policy.json
    }
  ]

  trusted_principles = [
    {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  ]
}

data "aws_caller_identity" "current" {}

data "aws_kms_key" "sm_key" {
  key_id = var.kms_key_id[local.workspace]
}

module "task_role" {
  source                  = "../tf-modules/iam/iam-role"
  name                    = "ecs-${local.workspace}-${var.ecs_service_name}-task-role"
  description             = "${var.role_description}-${var.ecs_service_name}"
  create_instance_profile = var.create_instance_profile
  trusted_principles      = local.trusted_principles
  inline_role_policy_list = local.inline_role_policy_list
  service_name            = var.ecs_service_name
  env                     = local.workspace
  extra_tags              = var.tags
  path                    = var.iam_role_path
}

data "aws_iam_policy_document" "s3_access_policy" {

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetObjectVersion"
    ]
    resources = [
      "arn:aws:s3:::terraform-state-4294",
      "arn:aws:s3:::terraform-state-4294/*"
    ]
  }
}

data "aws_iam_policy_document" "kms_secretmanager_access_policy" {

  statement {
    effect = "Allow"
    actions = [
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:DescribeKey",
      "kms:Decrypt"
    ]
    resources = [data.aws_kms_key.sm_key.arn]
  }
}

data "aws_iam_policy_document" "secretmanager_access_policy" {

  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = module.secretsmanager.secret_arns
  }
}

module "task_execution_role" {
  source                  = "../tf-modules/iam/iam-role"
  name                    = "ecs-${local.workspace}-${var.ecs_service_name}-task-execution-role"
  description             = "${var.role_description}-${var.ecs_service_name}"
  create_instance_profile = var.create_instance_profile
  trusted_principles      = local.trusted_principles
  inline_role_policy_list = local.inline_execution_role_policy_list
  service_name            = var.ecs_service_name
  env                     = local.workspace
  extra_tags              = var.tags
  path                    = var.iam_role_path
  custom_role_policy_arns = ["arn:aws:iam::${local.account_id}:policy/SecretManagerAWSAccessKeyAccess"]
}
