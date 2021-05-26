data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    dynamic "principals" {
      for_each = var.trusted_principles
      content {
        type        = principals.value["type"]
        identifiers = principals.value["identifiers"]
      }
    }
  }
}

resource "aws_iam_role" "this" {
  name                  = var.name
  description           = var.description
  max_session_duration  = var.max_session_duration
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
  permissions_boundary  = var.permissions_boundary
  force_detach_policies = var.force_detach_policies
  path                  = var.path

  tags = merge(
    var.extra_tags,
    {
      env          = var.env
      service_name = var.service_name
      Name         = var.name
    }
  )
}

resource "aws_iam_role_policy" "inline_policies" {
  count  = length(var.inline_role_policy_list)
  name   = var.inline_role_policy_list[count.index].name
  policy = var.inline_role_policy_list[count.index].policy
  role   = aws_iam_role.this.id
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = length(var.custom_role_policy_arns) > 0 ? length(var.custom_role_policy_arns) : 0

  role       = aws_iam_role.this.name
  policy_arn = element(var.custom_role_policy_arns, count.index)
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0
  name  = var.name
  path  = var.path
  role  = aws_iam_role.this.name
}

