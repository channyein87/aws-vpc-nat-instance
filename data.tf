locals {
  name = join("-", compact([var.name_prefix, "aws-vpc-nat-instance", var.name_suffix]))
  tags = merge({ Name = local.name }, var.tags)
}

data "aws_caller_identity" "current" {}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-*"]
  }
}

data "aws_iam_policy_document" "ssm_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:automation-execution/*"]
    }
  }
}

data "aws_iam_policy_document" "ssm_permissions" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:Describe*",
      "iam:PassRole",
      "ec2:AttachNetworkInterface"
    ]
  }
}
