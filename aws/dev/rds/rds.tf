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
      Environment = "Sandbox"
    }
  }
}

resource "aws_security_group" "allow_ml_svrs" {
  name        = var.rds_instance_id
  description = "Allow Postgres inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Machine learning Prod Server"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["10.251.21.90/32","10.251.21.14/32",]
  }

  ingress {
    description      = "Machine learning dev - INC43497004 server"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["10.251.36.99/32",]
  }

  ingress {
    description      = "AnyConnect VPN"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["10.218.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Machine Learning"
    Created     = var.creation_date
    CreatedBy   = var.created_by
    Owner       = var.owner
    #Application = var.application
    IAC_Tool    = "Terraform"
    Incident    = "N/A"
  }
}

resource "aws_db_subnet_group" "default" {
  description = "Private Dev Subnets"
  name       = "private dev subnets"
  subnet_ids = ["subnet-2a590000", "subnet-63696015"]

  tags = {
    Name        = "Machine Learning"
    Created     = var.creation_date
    CreatedBy   = var.created_by
    Owner       = var.owner
    #Application = var.application
    IAC_Tool    = "Terraform"
    Incident    = "N/A"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage               = 999
  db_subnet_group_name            = aws_db_subnet_group.default.name
  deletion_protection             = false
  enabled_cloudwatch_logs_exports = ["postgresql"]
  engine                          = "postgres"
  engine_version                  = "14.3"
  identifier                      = var.rds_instance_id
  instance_class                  = "db.t4g.xlarge"
  iops                            = 30000
  license_model                   = "postgresql-license"
  multi_az                        = true
  password                        = var.password
  performance_insights_enabled    = true
  publicly_accessible             = false
  skip_final_snapshot             = true
  storage_encrypted               = true
  storage_type                    = "io1"
  username                        = var.username
  vpc_security_group_ids          = [ aws_security_group.allow_ml_svrs.id ]
  tags = {
    Name        = "Machine Learning"
    Created     = var.creation_date
    CreatedBy   = var.created_by
    Owner       = var.owner
    #Application = var.application
    IAC_Tool    = "Terraform"
    Incident    = "N/A"
  }
}

output "db_instance_name" {
  value = aws_db_instance.default.id
}

output "db_instance_arn" {
  value = aws_db_instance.default.arn
}

output "db_instance_endpoint" {
  value = aws_db_instance.default.endpoint
}

output "ml_sg_id" {
  value = aws_security_group.allow_ml_svrs.id
}
