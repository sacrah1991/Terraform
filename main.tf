resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  tags = {
    Name = "my-vpc"
  }
}
#subnet public
resource "aws_subnet" "my_vpc-public-1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public-subnet-1_cidr
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone_names[0]

  tags = {
    Name = "public_subnet-1"
  }
}
resource "aws_subnet" "my_vpc-public-2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public-subnet-2_cidr
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone_names[1]

  tags = {
    Name = "public_subnet-2"
  }
}
#subnet private
resource "aws_subnet" "my_vpc-private-1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private-subnet-1_cidr
  map_public_ip_on_launch = "false"
  availability_zone       = var.availability_zone_names[0]

  tags = {
    Name = "private_subnet-1"
  }
}
resource "aws_subnet" "my_vpc-private-2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private-subnet-2_cidr
  map_public_ip_on_launch = "false"
  availability_zone       = var.availability_zone_names[1]

  tags = {
    Name = "private_subnet-2"
  }
}
#internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "internet_gateway"
  }
}
#route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "Route-1"
  }
}
resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.my_vpc-public-1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.my_vpc-public-2.id
  route_table_id = aws_route_table.public.id
}
# Creating Nat Gateway
resource "aws_eip" "nat" {
  vpc = true
}
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.my_vpc-public-1.id
  depends_on    = [aws_internet_gateway.my_igw]
}
# Add routes for VPC
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "private-1"
  }
}
# Creating route associations for private Subnets
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.my_vpc-private-1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.my_vpc-private-2.id
  route_table_id = aws_route_table.private.id
}
