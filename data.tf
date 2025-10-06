locals {
  name = join("-", compact([var.name_prefix, "aws-vpc-nat-instance", var.name_suffix]))
  tags = merge({ Name = local.name }, var.tags)
}

data "aws_ami" "ami" {
  most_recent = true
  filter {
    name   = "image-id"
    values = ["ami-01985677aac1a891b"]
  }
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}
