output "security_group_id" {
  description = "Security group id of the NAT instance."
  value       = aws_security_group.sg.id
}

output "eni_id" {
  description = "ID of the ENI for the NAT instance."
  value       = aws_network_interface.eni.id
}

output "instance_id" {
  description = "Ec2 instance id of the NAT instance."
  value       = aws_instance.nat.id
}
