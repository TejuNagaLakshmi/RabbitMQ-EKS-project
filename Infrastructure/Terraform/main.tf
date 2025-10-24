data "aws_availability_zones" "available" {}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.stack_name}-VPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.stack_name}-IGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name    = "Public Subnets"
    Network = "Public"
  }
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name    = "Private Subnet AZ1"
    Network = "Private01"
  }
}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name    = "Private Subnet AZ2"
    Network = "Private02"
  }
}

resource "aws_eip" "eip1" {
  vpc = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "eip2" {
  vpc = true
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_01_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name                         = "${var.stack_name}-PublicSubnet01"
    "kubernetes.io/role/elb"     = "1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_02_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name                         = "${var.stack_name}-PublicSubnet02"
    "kubernetes.io/role/elb"     = "1"
  }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_01_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name                                 = "${var.stack_name}-PrivateSubnet01"
    "kubernetes.io/role/internal-elb"    = "1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_02_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name                                 = "${var.stack_name}-PrivateSubnet02"
    "kubernetes.io/role/internal-elb"    = "1"
  }
}

resource "aws_nat_gateway" "ngw1" {
  allocation_id = aws_eip.eip1.allocation_id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "${var.stack_name}-NatGatewayAZ1"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "ngw2" {
  allocation_id = aws_eip.eip2.allocation_id
  subnet_id     = aws_subnet.public2.id

  tags = {
    Name = "${var.stack_name}-NatGatewayAZ2"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "private1_default" {
  route_table_id         = aws_route_table.private1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw1.id

  depends_on = [aws_nat_gateway.ngw1]
}

resource "aws_route" "private2_default" {
  route_table_id         = aws_route_table.private2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw2.id

  depends_on = [aws_nat_gateway.ngw2]
}

resource "aws_route_table_association" "public1_assoc" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2_assoc" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1_assoc" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "private2_assoc" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private2.id
}

resource "aws_security_group" "control_plane" {
  name        = "${var.stack_name}-control-plane-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.stack_name}-ControlPlaneSG"
  }
}
