#Defining the VPC
resource "aws_vpc" "UnifiPoller-VPC" {
  cidr_block       = var.VPC_CIDR_Block
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "UnifiPoller-VPC"
  }
}

#Defining Internet Gateway and Attaching into VPC
resource "aws_internet_gateway" "InternetGW" {
  vpc_id = aws_vpc.UnifiPoller-VPC.id

  tags = {
    Name = "InternetGW"
  }
}

#Defining PublicSubnet
resource "aws_subnet" "PublicSubnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.UnifiPoller-VPC.id
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "PublicSubnet"
  }
}

#Defining Public Route Table and Route to InternetGW
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.UnifiPoller-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.InternetGW.id
  }
  tags = {
    Name = "PublicRT"
  }
}

#Defining PublicSubnet and PublicRT Association
resource "aws_route_table_association" "AssociatePublicSubnettoPublicRT" {
  route_table_id = aws_route_table.PublicRT.id
  subnet_id = aws_subnet.PublicSubnet.id
}

