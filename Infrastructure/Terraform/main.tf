resource "aws_vpc" "demo-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  lifecycle {
    ignore_changes = [
      # Avoid attempting to modify DNS hostnames (requires ec2:ModifyVpcAttribute)
      enable_dns_hostnames,
    ]
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo-vpc.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.demo-vpc.id
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.demo-vpc.id
}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.demo-vpc.id
}



resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = var.public_subnet_01_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  lifecycle {
    # Avoid ModifySubnetAttribute (requires ec2:ModifySubnetAttribute) on existing subnets
    ignore_changes = [
      map_public_ip_on_launch,
    ]
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = var.public_subnet_02_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  lifecycle {
    # Avoid ModifySubnetAttribute (requires ec2:ModifySubnetAttribute) on existing subnets
    ignore_changes = [
      map_public_ip_on_launch,
    ]
  }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = var.private_subnet_01_cidr
  availability_zone = var.availability_zones[0]
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = var.private_subnet_02_cidr
  availability_zone = var.availability_zones[1]
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
  vpc_id      = aws_vpc.demo-vpc.id
  lifecycle {
    # Avoid modifying default egress rules on an existing SG (requires ec2:RevokeSecurityGroupEgress)
    ignore_changes = [
      egress,
    ]
  }
}
