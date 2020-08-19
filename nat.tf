# nat gateway
resource "aws_eip" "nat" {
  count = "${var.NUMBER_OF_AZ}"
  vpc = true
}

locals {
  nat_gateway_ips = aws_eip.nat.*.id
}

resource "aws_nat_gateway" "nat-gateway" {
  count = "${var.NUMBER_OF_AZ}"
  allocation_id = "${element(local.nat_gateway_ips , count.index)}"
  subnet_id     = aws_subnet.octopus-public-subnet[count.index].id
  depends_on    = [aws_internet_gateway.main-gateway]

  tags = {
    Name = "nat gateway ${count.index}"
  }
}

# VPC setup for NAT
resource "aws_route_table" "main-private" {
  count = "${var.NUMBER_OF_AZ}"
  vpc_id = aws_vpc.octopus-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway[count.index].id
  }

  tags = {
    Name = "main-private ${count.index}"
  }
}

# route associations private
resource "aws_route_table_association" "main-private" {
  count = "${var.NUMBER_OF_AZ}"
  subnet_id      = aws_subnet.octopus-private-subnet[count.index].id
  route_table_id = aws_route_table.main-private[count.index].id
}
