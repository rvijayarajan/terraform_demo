variable "public_subnet_id" {}
variable "vpc_id" {}
variable "asg_min" {
  default = "2"
}
variable "asg_max" {
  default = "4"
}