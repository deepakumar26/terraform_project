# Creating custom vpc

resource "aws_vpc" "cards_website_vpc" {
  cidr_block = var.vpc_cidr
}

# Creating the public subnet in one availability zone

resource "aws_subnet" "cards_website_subnet_public_1a" {
  vpc_id            = aws_vpc.cards_website_vpc.id
  cidr_block        = var.vpc_subnet_cidr_public_1a
  map_public_ip_on_launch = true
  availability_zone = var.vpc_az_1a
}

# Creating the public subnet in one availability zone

resource "aws_subnet" "cards_website_subnet_public_1b" {
  vpc_id            = aws_vpc.cards_website_vpc.id
  cidr_block        = var.vpc_subnet_cidr_public_1b
  map_public_ip_on_launch = true
  availability_zone = var.vpc_az_1b
}

# Creating the private subnet in one availability zone

resource "aws_subnet" "cards_website_subnet_private_1a" {
  vpc_id            = aws_vpc.cards_website_vpc.id
  cidr_block        = var.vpc_subnet_cidr_private_1a
  availability_zone = var.vpc_az_1a
}

# Creating the private subnet in one availability zone

resource "aws_subnet" "cards_website_subnet_private_1b" {
  vpc_id            = aws_vpc.cards_website_vpc.id
  cidr_block        = var.vpc_subnet_cidr_private_1b
  availability_zone = var.vpc_az_1b
}

# Creating the internet gateway to provide internet to servers in public subnet

resource "aws_internet_gateway" "cards_website_igw" {
  vpc_id = aws_vpc.cards_website_vpc.id
}

# Creating the public route table to route the traffic to server in public subnet

resource "aws_route_table" "cards_website_public_rt" {
  vpc_id = aws_vpc.cards_website_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cards_website_igw.id
  }
}

# Creating the route association for public subnet
resource "aws_route_table_association" "subnet_association_1a" {
  subnet_id      = aws_subnet.cards_website_subnet_public_1a.id
  route_table_id = aws_route_table.cards_website_public_rt.id
}

resource "aws_route_table_association" "subnet_association_1b" {
  subnet_id      = aws_subnet.cards_website_subnet_public_1b.id
  route_table_id = aws_route_table.cards_website_public_rt.id
}

/* ============================================================*/


# Creating the NAT gateway in public subnet 1a
resource "aws_eip" "nat_eip_1a" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "cards_website_nat_gw_1a" {
  allocation_id = aws_eip.nat_eip_1a.id
  subnet_id     = aws_subnet.cards_website_subnet_public_1a.id
}

# Creating the NAT gateway in public subnet 1b
resource "aws_eip" "nat_eip_1b" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "cards_website_nat_gw_1b" {
  allocation_id = aws_eip.nat_eip_1b.id
  subnet_id     = aws_subnet.cards_website_subnet_public_1b.id
}

# Creating the private route table for subnet 1a
resource "aws_route_table" "cards_website_private_rt_1a" {
  vpc_id = aws_vpc.cards_website_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cards_website_nat_gw_1a.id
  }
}

# Creating the private route table for subnet 1b
resource "aws_route_table" "cards_website_private_rt_1b" {
  vpc_id = aws_vpc.cards_website_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cards_website_nat_gw_1b.id
  }
}

# Creating the private route table association with private subnet 1a
resource "aws_route_table_association" "private_subnet_association_1a" {
  subnet_id      = aws_subnet.cards_website_subnet_private_1a.id
  route_table_id = aws_route_table.cards_website_private_rt_1a.id
}

# Creating the private route table association with private subnet 1b
resource "aws_route_table_association" "private_subnet_association_1b" {
  subnet_id      = aws_subnet.cards_website_subnet_private_1b.id
  route_table_id = aws_route_table.cards_website_private_rt_1b.id
}