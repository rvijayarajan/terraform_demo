resource "aws_launch_template" "bupttemplate" {
  name = "bupttemplate"
  image_id = "ami-005c06c6de69aee84"
  instance_type = "t2.micro"
  key_name = "buptlab"
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp2"
      delete_on_termination = "true"
    }
  }
}

output "webapp_lt_id" {
  value = aws_launch_template.bupttemplate.id
}
output "webapp_lt_name" {
  value = aws_launch_template.bupttemplate.name
}
