resource "aws_autoscaling_group" "webapp_asg" {
  lifecycle { create_before_destroy = true }
  vpc_zone_identifier = [var.public_subnet_id]
  name = "demo_webapp_asg-${var.webapp_lt_name}"
  max_size = var.asg_max
  min_size = var.asg_min
#   wait_for_elb_capacity = false
  force_delete = true
  launch_configuration = var.webapp_lt_id
  load_balancers = [var.webapp_elb_name]
  tag {
    key = "Name"
    value = "buptlab_asg"
    propagate_at_launch = "true"
  }
}

#
# Scale Up Policy and Alarm
#
resource "aws_autoscaling_policy" "scale_up" {
  name = "buptlab_asg_scale_up"
  scaling_adjustment = 2
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}

#
# Scale Down Policy and Alarm
#
resource "aws_autoscaling_policy" "scale_down" {
  name = "buptlab_asg_scale_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 600
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
}

output "asg_id" {
  value = aws_autoscaling_group.webapp_asg.id
}
