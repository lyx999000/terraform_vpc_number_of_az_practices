# Internet VPC
resource "aws_vpc" "octopus-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "octopus-VPC"
  }
}

# Subnets
resource "aws_subnet" "octopus-public-subnet" {
  count = "${var.NUMBER_OF_AZ}"
  vpc_id                  = aws_vpc.octopus-vpc.id
  cidr_block              = "10.0.${1 + count.index}.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "octopus-public-subnet ${count.index}"
  }
}


resource "aws_subnet" "octopus-private-subnet" {
  count = "${var.NUMBER_OF_AZ}"
  vpc_id                  = aws_vpc.octopus-vpc.id
  cidr_block              = "10.0.${101 + count.index}.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "octopus-private-subnet ${count.index}"
  }
}


# internet gateway
resource "aws_internet_gateway" "main-gateway" {
  vpc_id = aws_vpc.octopus-vpc.id

  tags = {
    Name = "main"
  }
}

# route tables
resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.octopus-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gateway.id
  }

  tags = {
    Name = "main-public"
  }
}

# route associations public
resource "aws_route_table_association" "main-public-subnet" {
  count = "${var.NUMBER_OF_AZ}"
  subnet_id      = aws_subnet.octopus-public-subnet[count.index].id
  route_table_id = aws_route_table.main-public.id
}

