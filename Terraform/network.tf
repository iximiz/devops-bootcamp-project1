resource "aws_vpc" "devops_vpc" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "devops-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "10.0.0.0/25"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "devops-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.devops_vpc.id
  cidr_block        = "10.0.0.128/25"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "devops-private-subnet"
  }
}

resource "aws_internet_gateway" "devops_igw" {
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name = "devops-igw"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.devops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_igw.id
  }

  tags = {
    Name = "devops-public-route"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name = "devops-private-route"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "devops-nat-eip"
  }
}

resource "aws_nat_gateway" "devops_ngw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "devops-ngw"
  }

  depends_on = [
    aws_internet_gateway.devops_igw
  ]
}

resource "aws_route" "private_internet" {
  route_table_id         = aws_route_table.private_route.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.devops_ngw.id
}