provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "example"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets      = ["10.0.64.0/20", "10.0.80.0/20", "10.0.96.0/20"]
  public_subnets       = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]
  enable_dns_hostnames = true
}

module "nat" {
  source = "../.."

  vpc_id               = module.vpc.vpc_id
  public_subnet_id     = module.vpc.public_subnets[0]
  route_table_ids      = module.vpc.private_route_table_ids
  iam_instance_profile = "ec2-ssm-role"
  key_pair_name        = "example"

  schedule_scale_up = {
    enabled    = true
    recurrence = "0 9 * * *"
  }
}
