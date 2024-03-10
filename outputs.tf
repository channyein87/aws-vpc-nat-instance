output "launch_template_id" {
  description = "The ID of the launch template."
  value       = one(aws_launch_template.lt[*].id)
}

output "launch_template_arn" {
  description = "The ARN of the launch template."
  value       = one(aws_launch_template.lt[*].arn)
}

output "autoscaling_group_id" {
  description = "The AutoScaling Group id."
  value       = aws_autoscaling_group.asg.id
}

output "autoscaling_group_name" {
  description = "The AutoScaling Group name."
  value       = aws_autoscaling_group.asg.name
}

output "autoscaling_group_arn" {
  description = "ARN of the AutoScaling Group."
  value       = aws_autoscaling_group.asg.arn
}

output "security_group_id" {
  description = "Security group id of the NAT instance."
  value       = aws_security_group.sg.id
}

output "eni_id" {
  description = "ID of the ENI for the NAT instance."
  value       = aws_network_interface.eni.id
}

output "ssm_document_arn" {
  description = "The ARN of the SSM automation document."
  value       = aws_ssm_document.automation.arn
}

output "ssm_automation_role_arn" {
  description = "The ARN of the SSM automation role."
  value       = aws_iam_role.ssm.arn
}
