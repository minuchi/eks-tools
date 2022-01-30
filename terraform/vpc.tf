locals {
  ip_prefix = "10.100"
}

resource "aws_vpc" "main" {
  cidr_block           = "${local.ip_prefix}.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "gw" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = "${local.ip_prefix}.${255 - count.index}.0/24"
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "gw.${var.availability_zones[count.index]}"
  }
}

resource "aws_subnet" "prvt" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = "${local.ip_prefix}.${count.index * 32}.0/19"
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "prvt.${var.availability_zones[count.index]}"
  }
}

resource "aws_eip" "nat_ip" {
  vpc = true

  tags = {
    Name = var.availability_zones[0]
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.gw[0].id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "${var.availability_zones[0]}"
  }
}

resource "aws_route_table" "gw" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "gw"
  }
}

resource "aws_route_table" "prvt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "prvt"
  }
}

resource "aws_route_table_association" "gw" {
  count = length(aws_subnet.gw)

  subnet_id      = aws_subnet.gw[count.index].id
  route_table_id = aws_route_table.gw.id
}

resource "aws_route_table_association" "prvt" {
  count = length(aws_subnet.gw)

  subnet_id      = aws_subnet.prvt[count.index].id
  route_table_id = aws_route_table.prvt.id
}
