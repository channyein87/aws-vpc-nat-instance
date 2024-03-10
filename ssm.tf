resource "aws_iam_role" "ssm" {
  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.ssm_assume.json
  tags               = local.tags
}

resource "aws_iam_role_policy" "ssm" {
  name   = local.name
  role   = aws_iam_role.ssm.id
  policy = data.aws_iam_policy_document.ssm_permissions.json
}

resource "aws_ssm_document" "automation" {
  name            = join("-", compact([var.name_prefix == null ? "self" : "", local.name]))
  document_type   = "Automation"
  document_format = "YAML"
  content         = file("${path.module}/attach_eni_ssm.yaml")
}

resource "aws_ssm_association" "association" {
  association_name = local.name
  name             = aws_ssm_document.automation.name

  automation_target_parameter_name = "InstanceId"
  schedule_expression              = "cron(0 2 ? * SUN *)"
  compliance_severity              = "LOW"

  dynamic "targets" {
    for_each = var.ssm_association_tag

    content {
      key    = "tag:${targets.key}"
      values = [targets.value]
    }
  }

  parameters = {
    "ENI"  = aws_network_interface.eni.id
    "Role" = aws_iam_role.ssm.arn
  }
}
