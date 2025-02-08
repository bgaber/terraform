data "aws_instance" "instance" {
  instance_id = "i-1234567890abcdef0"
}

resource "aws_security_group" "sg" {
  tags = {
    type = "terraform-test-security-group"
  }
}

resource "aws_security_group" "allow_ldap" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "LDAP from EPW099WDC01 and EPW099WDC02"
    from_port        = 389
    to_port          = 389
    protocol         = "tcp"
    cidr_blocks      = ["10.17.6.245/32", "10.17.6.246/32"]
  }

  ingress {
    description      = "LDAPS from EPW099WDC01 and EPW099WDC02"
    from_port        = 636
    to_port          = 636
    protocol         = "tcp"
    cidr_blocks      = ["10.17.6.245/32", "10.17.6.246/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Created = "15 Oct 2022"
    Creator = "Brian Gaber"
    IAC_Tool = "Terraform"
    Application = "Forgerock"
    Owner = "Michael Graf"
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.sg.id
  network_interface_id = data.aws_instance.instance.network_interface_id
}