terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "US-Prod"
}

resource "aws_security_group" "allow_qualys" {
  name        = "Qualys Scanner Appliance"
  description = "Qualys Scanner Appliance"
  vpc_id      = "vpc-cde65aaa"

  ingress {
    description      = "Qualys Scanner Appliance IP"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["161.108.208.215/32","10.251.3.174/32","10.17.0.224/32","10.17.1.27/32","10.17.1.30/32"]
  }

  ingress {
    description      = "Qualys Scanner Appliance IP"
    from_port        = 0
    to_port          = 65535
    protocol         = "udp"
    cidr_blocks      = ["161.108.208.215/32","10.251.3.174/32","10.17.0.224/32","10.17.1.27/32","10.17.1.30/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Qualys Scanner Appliance"
    Created = "20 Oct 2022"
    Creator = "Brian Gaber"
    IAC_Tool = "Terraform"
    Application = "Qualys"
    Owner = "Shashank Gahoi"
    Incident = "INC44359425"
  }
}