# https://www.cloudbolt.io/terraform-best-practices/terraform-dynamic-blocks/

locals {
  inbound_tcp_rules = [
    { port = 53, protocol = "tcp" },    # DNS
    { port = 88, protocol = "tcp" },    # Kerberos
    { port = 135, protocol = "tcp" },   # RPC Endpoint Mapper
    { port = 389, protocol = "tcp" },   # LDAP
    { port = 445, protocol = "tcp" },   # SMB
    { port = 464, protocol = "tcp" },   # Kerberos (password)
    { port = 636, protocol = "tcp" },   # LDAP SSL
    { port = 3268, protocol = "tcp" },  # LDAP Global Catalog
    { port = 3269, protocol = "tcp" }   # LDAP Global Catalog SSL
  ]
  inbound_udp_rules = [
    { port = 53, protocol = "udp" },    # DNS
    { port = 88, protocol = "udp" },    # Kerberos
    { port = 123, protocol = "udp" },   # Time Sync (NTP)
    { port = 389, protocol = "udp" },   # LDAP
    { port = 464, protocol = "udp" },   # Kerberos (password)
  ]
}
resource "aws_security_group" "allow_delinea" {
  name        = "Delinea DC Communication #1"
  description = "Delinea DC Communication #1"
  vpc_id      = "vpc-8ae1c9e3"

  dynamic ingress {
    for_each = local.inbound_tcp_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = var.canada_cidrs
    }
  }

  dynamic ingress {
    for_each = local.inbound_udp_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = var.canada_cidrs
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

output "aws_security_group_id" {
  value = aws_security_group.allow_delinea.id
}