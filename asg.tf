resource "aws_launch_template" "lt" {
  count = var.lunch_template_id == null ? 1 : 0

  name        = local.name
  description = "Launch template for ${local.name}"
  tags        = local.tags
  image_id    = data.aws_ami.ami.id
  key_name    = var.key_pair_name

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.sg.id]
    delete_on_termination       = true
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = lookup(var.ebs, "delete_on_termination", null)
      encrypted             = lookup(var.ebs, "encrypted", null)
      iops                  = lookup(var.ebs, "iops", null)
      throughput            = lookup(var.ebs, "throughput", null)
      kms_key_id            = lookup(var.ebs, "kms_key_id", null)
      volume_size           = lookup(var.ebs, "volume_size", null)
      volume_type           = lookup(var.ebs, "volume_type", null)
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(local.tags, var.ssm_association_tag)
  }

  dynamic "tag_specifications" {
    for_each = toset(["volume", "network-interface"])

    content {
      resource_type = tag_specifications.value
      tags          = local.tags
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = local.name
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 1
  health_check_grace_period = 30

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = var.lunch_template_id == null ? one(aws_launch_template.lt[*].id) : var.lunch_template_id
        version            = "$Latest"
      }

      dynamic "override" {
        for_each = var.instance_types

        content {
          instance_type = override.value
        }
      }
    }

    instances_distribution {
      on_demand_base_capacity                  = var.spot ? 0 : 1
      on_demand_percentage_above_base_capacity = var.spot ? 0 : 100
    }
  }

  dynamic "tag" {
    for_each = local.tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
