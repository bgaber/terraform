terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.39"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.cred_profile
  default_tags {
    tags = {
      Created     = var.creation_date
      CreatedBy   = var.created_by
      Owner       = var.owner
      #Application = var.application
      Environment = var.cred_profile
    }
  }
}

# data source vpc object
data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "allow_active_mq" {
  name        = var.security_group_name
  description = "Allow access from Internal CompuCom"

  ingress {
    description      = "DIMS SPL099PAS01 - Steve Best"
    from_port        = 61617
    to_port          = 61617
    protocol         = "tcp"
    cidr_blocks      = ["10.16.0.5/32"]
  }

  ingress {
    description      = "DIMS SQL099PAS01 - Steve Best"
    from_port        = 61617
    to_port          = 61617
    protocol         = "tcp"
    cidr_blocks      = ["10.16.0.13/32"]
  }

  ingress {
    description      = "OpenWire and STOMP"
    from_port        = 61617
    to_port          = 61617
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.selected.cidr_block]
  }

  ingress {
    description      = "WSS"
    from_port        = 61616
    to_port          = 61616
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.selected.cidr_block]
  }

  ingress {
    description      = "AMQP"
    from_port        = 5671
    to_port          = 5671
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.selected.cidr_block]
  }

  ingress {
    description      = "MQTT"
    from_port        = 8883
    to_port          = 8883
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.selected.cidr_block]
  }

  ingress {
    description      = "network-troubleshooting"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["10.218.0.0/16"]
  }

  ingress {
    description      = "ActiveMQ Web Console Access from AnyConnect VPN"
    from_port        = 8162
    to_port          = 8162
    protocol         = "tcp"
    cidr_blocks      = ["10.218.0.0/16"]
  }

  tags = {
    Name        = "BB Modernization"
    Created     = var.creation_date
    CreatedBy   = var.created_by
    Owner       = var.owner
    #Application = var.application
    IAC_Tool    = "Terraform"

  }
  vpc_id        = data.aws_vpc.selected.id
}

resource "aws_mq_broker" "bb_modernization" {
  authentication_strategy    = "simple"
  auto_minor_version_upgrade = true
  broker_name                = "BB-Modernization-Amazon-MQ-Broker"
  deployment_mode            = "ACTIVE_STANDBY_MULTI_AZ"
  engine_type                = "ActiveMQ"
  engine_version             = "5.17.2"
  host_instance_type         = var.instance_type
  maintenance_window_start_time {
    day_of_week = "Sunday"
    time_of_day = "02:00:00"
    time_zone   = "America/Toronto"
  }
  publicly_accessible = false
  security_groups     = [aws_security_group.allow_active_mq.id]
  subnet_ids          = var.mq_priv_subnets
  tags = {
    Name        = "BB Modernization"
    Created     = var.creation_date
    CreatedBy   = var.created_by
    Owner       = var.owner
    #Application = var.application
    IAC_Tool    = "Terraform"
  }
  user {
    username = var.username
    password = var.password
  }
}

output "vpc_cidr_block" {
  value = data.aws_vpc.selected.cidr_block
}
output "amazon_mq_broker_id" {
  value = aws_mq_broker.bb_modernization.id
}

output "amazon_mq_broker_arn" {
  value = aws_mq_broker.bb_modernization.arn
}

output "amazon_mq_broker_console_url" {
  value = aws_mq_broker.bb_modernization.instances.0.console_url
}

output "amazon_mq_broker_end_points" {
  value = aws_mq_broker.bb_modernization.instances.0.endpoints
}
