output "VpcID" {
  value = aws_vpc.UnifiPoller-VPC.id
}

output "PublicSubnet" {
  value = aws_subnet.PublicSubnet.id
}
