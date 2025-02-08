resource "aws_security_group" "allow_ml_svrs" {
  name        = var.rds_instance_id
  description = "Allow Postgres inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "AWX K8s Cluster Worker Nodes"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["10.251.36.0/22","10.251.40.0/22",]
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
}

resource "aws_db_subnet_group" "default" {
  description = "Private Dev Subnets"
  name       = "private dev subnets"
  subnet_ids = ["subnet-2a590000", "subnet-63696015"]
}

resource "aws_db_instance" "default" {
  allocated_storage               = 999
  db_subnet_group_name            = aws_db_subnet_group.default.name
  deletion_protection             = false
  enabled_cloudwatch_logs_exports = ["postgresql"]
  engine                          = "postgres"
  engine_version                  = "15.6"
  identifier                      = var.rds_instance_id
  instance_class                  = "db.c6gd.medium"
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
}

output "db_instance_id" {
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
