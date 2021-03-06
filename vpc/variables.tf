variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the Private Subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr_2" {
  description = "CIDR for the Private Subnet 2"
  default = "10.0.2.0/24"
}

variable "availability_zones" {
  # No spaces allowed between az names!
  default = ["us-west-1b","us-west-1c"]
}