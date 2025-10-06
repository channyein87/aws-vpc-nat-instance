resource "aws_instance" "nat" {
  ami                  = data.aws_ami.ami.id
  instance_type        = var.instance_type
  key_name             = var.key_pair_name
  iam_instance_profile = var.iam_instance_profile
  tags                 = local.tags

  primary_network_interface {
    network_interface_id = aws_network_interface.eni.id
  }

  root_block_device {
    delete_on_termination = var.ebs.delete_on_termination
    encrypted             = var.ebs.encrypted
    iops                  = var.ebs.iops
    throughput            = var.ebs.throughput
    kms_key_id            = var.ebs.kms_key_id
    volume_size           = var.ebs.volume_size
    volume_type           = var.ebs.volume_type
    tags                  = local.tags
  }

  dynamic "instance_market_options" {
    for_each = var.spot ? [1] : []

    content {
      market_type = "spot"
    }
  }
}
