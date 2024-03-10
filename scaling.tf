resource "aws_autoscaling_schedule" "up" {
  count = var.schedule_scale_up.enabled ? 1 : 0

  autoscaling_group_name = aws_autoscaling_group.asg.name
  scheduled_action_name  = "scale-up"
  min_size               = 1
  max_size               = 1
  desired_capacity       = 1
  recurrence             = var.schedule_scale_up.recurrence
  time_zone              = var.schedule_scale_up.time_zone
}

resource "aws_autoscaling_schedule" "down" {
  count = var.schedule_scale_down.enabled ? 1 : 0

  autoscaling_group_name = aws_autoscaling_group.asg.name
  scheduled_action_name  = "scale-down"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 0
  recurrence             = var.schedule_scale_down.recurrence
  time_zone              = var.schedule_scale_down.time_zone
}
