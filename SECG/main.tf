resource "aws_security_group" "UnifiPoller-SecG" {
  name = "UnifiPoller-SecG"
  vpc_id = var.VpcId
  description = "Outbound/Inbound Rules for UnifiPoller Instance"
  egress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    cidr_blocks     = ["0.0.0.0/0"] #For Internet Connection
  }
  egress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    cidr_blocks     = ["0.0.0.0/0"] #For Internet Connection
  }
  egress {
    protocol        = "tcp"
    from_port       = 8443
    to_port         = 8443
    cidr_blocks     = ["0.0.0.0/0"] #For Unifi-Poller to connect Ubiquiti.
  }
  ingress {
    protocol = "tcp"
    from_port = 3000
    to_port = 3000
    cidr_blocks = ["0.0.0.0/0"] #For Graphana Connection
  }
}

