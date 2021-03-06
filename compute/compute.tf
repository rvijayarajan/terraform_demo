resource "aws_security_group" "mysql_inbound_sg" {
  name = "mysql_inbound"
  description = "Allow access for mysql"
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id
  tags = {
      Name = "buptlab_mysql"
  }
}

resource "aws_security_group" "ec2_instance_inbound_sg" {
  name = "ec2_inbound"
  description = "Allow access for Ec2"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id
  tags = {
      Name = "buptlab_ec2"
  }
}

resource "aws_security_group" "webapp_http_inbound_sg" {
  name = "demo_webapp_http_inbound"
  description = "Allow HTTP from Anywhere"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id
  tags = {
      Name = "buptlab_webdmz_inbound"
  }
}

resource "aws_security_group" "webapp_outbound_sg" {
  name = "demo_webapp_outbound"
  description = "Allow outbound connections"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc_id
  tags = {
      Name = "buptlab_webdmz_outbound"
  }
}

resource "aws_launch_template" "bupttemplate" {
  name = "bupttemplate"
  image_id = "ami-005c06c6de69aee84"
  instance_type = "t2.micro"
  key_name = "buptlab"
  # block_device_mappings {
  #   device_name = "/dev/sda1"

  #   ebs {
  #     volume_size = 8
  #     volume_type = "gp2"
  #     delete_on_termination = "true"
  #   }
  # }
  iam_instance_profile {
    name = "JenkinsCIRole"
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.ec2_instance_inbound_sg.id]
  }
  # security_group_names = [aws_security_group.ec2_instance_inbound_sg.name]
  user_data = filebase64("compute/compute.sh")
}

resource "aws_elb" "webapp_elb" {
  name = "bupt-elb"
  subnets = [var.public_subnet_id]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 10
  }
  security_groups = [aws_security_group.webapp_http_inbound_sg.id]
  tags = {
      Name = "buptlab_elb"
  }
}

resource "aws_autoscaling_group" "webapp_asg" {
  lifecycle { create_before_destroy = true }
  vpc_zone_identifier = [var.public_subnet_id]
  # availability_zones = [var.region]
  name = "demo_webapp_asg-${aws_launch_template.bupttemplate.name}"
  max_size = var.asg_max
  min_size = var.asg_min
#   wait_for_elb_capacity = false
  force_delete = true
  launch_template {
    id = aws_launch_template.bupttemplate.id
    version = "$Latest"
  }
  load_balancers = [aws_elb.webapp_elb.name]
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
