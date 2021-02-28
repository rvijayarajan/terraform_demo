variable "asg_min" {
  default = "2"
}
variable "asg_max" {
  default = "4"
}

variable "public_subnet_id" {}
variable "webapp_lt_id" {}
variable "webapp_lt_name" {}
variable "webapp_elb_name" {}