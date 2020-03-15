# nat gw
# create a static IP address
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.jo-001-public-1.id
  depends_on    = [aws_internet_gateway.jo-001-gw]
}

# VPC setup for NAT
resource "aws_route_table" "jo-001-private" {
  vpc_id = aws_vpc.jo-001.id
  route {
      cidr_block       = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
      Name = "jo-001-private-1"
  }
}

# route associations private
resource "aws_route_table_association" "jo-001-private-1-a" {
  subnet_id      = aws_subnet.jo-001-private-1.id
  route_table_id = aws_route_table.jo-001-private.id
}

resource "aws_route_table_association" "jo-001-private-2-a" {
  subnet_id      = aws_subnet.jo-001-private-2.id
  route_table_id = aws_route_table.jo-001-private.id
}

resource "aws_route_table_association" "jo-001-private-3-a" {
  subnet_id      = aws_subnet.jo-001-private-3.id
  route_table_id = aws_route_table.jo-001-private.id
}