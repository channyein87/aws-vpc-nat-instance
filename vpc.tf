resource "aws_security_group" "sg" {
  name        = local.name
  description = "Security group for ${local.name}"
  vpc_id      = var.vpc_id
  tags        = local.tags
}

resource "aws_security_group_rule" "egress" {
  security_group_id = aws_security_group.sg.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

resource "aws_security_group_rule" "ingress" {
  security_group_id = aws_security_group.sg.id
  type              = "ingress"
  cidr_blocks       = compact(concat([data.aws_vpc.vpc.cidr_block], var.security_group_inbound_cidrs))
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

resource "aws_network_interface" "eni" {
  security_groups   = [aws_security_group.sg.id]
  subnet_id         = var.public_subnet_id
  source_dest_check = false
  description       = "ENI for ${local.name}"
  tags              = local.tags
}

resource "aws_route" "route" {
  for_each = { for index, subnet in var.route_table_ids : index => subnet }

  route_table_id         = each.value
  network_interface_id   = aws_network_interface.eni.id
  destination_cidr_block = "0.0.0.0/0"
}
