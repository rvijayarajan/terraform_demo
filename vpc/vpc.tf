resource "aws_vpc" "default" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
      Name = "bupt_vpc"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
      Name = "bupt_igw"
  }
}
output "vpc_id" {
  value = aws_vpc.default.id
}

#
# Public Subnet
#
resource "aws_subnet" "demo_public" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.public_subnet_cidr
  availability_zone = element(var.availability_zones, 0)
  tags = {
      Name = "Bupt_public_subnet"
  }
}
output "public_subnet_id" {
  value = aws_subnet.demo_public.id
}

resource "aws_route_table" "demo_public" {
  vpc_id = aws_vpc.default.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.default.id
  }
  tags = {
      Name = "Bupt_Route_Table"
  }
}

resource "aws_route_table_association" "demo_public" {
  subnet_id = aws_subnet.demo_public.id
  route_table_id = aws_route_table.demo_public.id
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
  vpc_id = aws_vpc.default.id
  tags = {
      Name = "buptlab_webdmz_inbound"
  }
}
output "webapp_http_inbound_sg_id" {
  value = aws_security_group.webapp_http_inbound_sg.id
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
  vpc_id = aws_vpc.default.id
  tags = {
      Name = "buptlab_webdmz_outbound"
  }
}
output "webapp_outbound_sg_id" {
  value = aws_security_group.webapp_outbound_sg.id
}