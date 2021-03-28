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

#
# Private Subnet 1
#
resource "aws_subnet" "demo_private" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.private_subnet_cidr
  availability_zone = element(var.availability_zones, 0)
  tags = {
      Name = "Bupt_private_subnet"
  }
}

resource "aws_route_table" "demo_private" {
  vpc_id = aws_vpc.default.id
  tags = {
      Name = "Bupt_Route_Table"
  }
}

resource "aws_route_table_association" "demo_private" {
  subnet_id = aws_subnet.demo_private.id
  route_table_id = aws_route_table.demo_private.id
}

#
# Private Subnet 2
#
resource "aws_subnet" "demo_private2" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.private_subnet_cidr_2
  availability_zone = element(var.availability_zones, 1)
  tags = {
      Name = "Bupt_private_subnet_2"
  }
}

resource "aws_route_table" "demo_private2" {
  vpc_id = aws_vpc.default.id
  tags = {
      Name = "Bupt_Route_Table_2"
  }
}

resource "aws_route_table_association" "demo_private2" {
  subnet_id = aws_subnet.demo_private2.id
  route_table_id = aws_route_table.demo_private2.id
}

resource "aws_db_subnet_group" "dbsubnetgroup" {
  name       = "mysqlsubnetgroup"
  subnet_ids = [aws_subnet.demo_private.id, aws_subnet.demo_private2.id]

  tags = {
    Name = "My SQL subnet group"
  }
}
