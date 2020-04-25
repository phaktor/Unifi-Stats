data "aws_ami" "ubuntu-ami" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "aws_network_interface" "UnifiPoller-Instance-NetworkInterface" {
  subnet_id = var.PublicSubnet
  security_groups = [var.UnifiPoller-SecG]
}

resource "aws_eip" "ElasticIP" {
  vpc = true
}

//data "template_file" "package_installer" {
//  template = file("Scripts/installer.sh")
//}

resource "aws_instance" "UnifiPoller-Instance" {
  ami = data.aws_ami.ubuntu-ami.id
  instance_type = "t2.micro"
  iam_instance_profile = var.SSM-Instance-Profile
//  user_data = data.template_file.package_installer.rendered
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.UnifiPoller-Instance-NetworkInterface.id
  }

  tags = {
    Name = "UnifiPoller-Instance"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.UnifiPoller-Instance.id
  allocation_id = aws_eip.ElasticIP.id
}
