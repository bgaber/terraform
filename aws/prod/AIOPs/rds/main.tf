resource "aws_security_group" "allow_awx" {
  name        = var.rds_instance_id
  description = "Allow Postgres inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "AWX K8s Cluster Worker Nodes"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["10.251.24.0/22","10.251.20.0/22",]
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

resource "aws_db_subnet_group" "aiops_awx" {
  description = "Private Prod Subnets"
  name       = "private prod subnets"
  subnet_ids = ["subnet-916861e7", "subnet-c25801e8"]
}

resource "aws_db_instance" "aiops_awx" {
  allocated_storage               = 100
  db_name                         = var.database_name
  db_subnet_group_name            = aws_db_subnet_group.aiops_awx.name
  deletion_protection             = false
  enabled_cloudwatch_logs_exports = ["postgresql"]
  engine                          = "postgres"
  engine_version                  = "15.6"
  identifier                      = var.rds_instance_id
  instance_class                  = "db.c6gd.medium"
  #iops                            = 30000
  license_model                   = "postgresql-license"
  multi_az                        = true
  password                        = var.password
  performance_insights_enabled    = true
  publicly_accessible             = false
  skip_final_snapshot             = true
  storage_encrypted               = true
  storage_type                    = "gp3"
  username                        = var.username
  vpc_security_group_ids          = [ aws_security_group.allow_awx.id ]
}

output "db_instance_id" {
  value = aws_db_instance.aiops_awx.id
}

output "db_instance_arn" {
  value = aws_db_instance.aiops_awx.arn
}

output "db_instance_endpoint" {
  value = aws_db_instance.aiops_awx.endpoint
}

output "pgsql_db_sg_id" {
  value = aws_security_group.allow_awx.id
}
