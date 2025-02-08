data "aws_partition" "current" {}

data "aws_caller_identity" "prod" {}

locals {
    account_id = data.aws_caller_identity.prod.account_id
}

# ECS Cluster
resource "aws_ecs_cluster" "genesys_chat_translator_cluster_prod" {
  name = var.ecs_cluster_name
}

# IAM Policy for ECS Task
resource "aws_iam_policy" "connect_genesys_prod_ecs_task_policy" {
  name = "connect-genesys-prod-ecs-task-policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "kendra:SubmitFeedback",
                "kendra:Query",
                "cognito-identity:*",
                "dynamodb:ListTables",
                "dynamodb:ListBackups",
                "dynamodb:PurchaseReservedCapacityOfferings",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:CreateControlChannel",
                "dynamodb:ListStreams",
                "ssmmessages:CreateDataChannel",
                "dynamodb:ListContributorInsights",
                "dynamodb:DescribeReservedCapacityOfferings",
                "dynamodb:ListGlobalTables",
                "dynamodb:DescribeReservedCapacity",
                "ssmmessages:OpenDataChannel",
                "cognito-idp:*",
                "dynamodb:ListImports",
                "dynamodb:DescribeLimits",
                "dynamodb:DescribeEndpoints",
                "dynamodb:ListExports"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "dynamodb:*",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:${var.prod_region}:${local.account_id}:log-group:/aws/lambda/*:log-stream:*",
                "arn:aws:dynamodb:*:${local.account_id}:table/*"
            ]
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "dynamodb:BatchWriteItem",
                "logs:CreateLogGroup"
            ],
            "Resource": [
                "arn:aws:logs:${var.prod_region}:${local.account_id}:log-group:/aws/lambda/*",
                "arn:aws:dynamodb:*:${local.account_id}:table/*"
            ]
        },
        {
            "Sid": "VisualEditor3",
            "Effect": "Allow",
            "Action": "dynamodb:*",
            "Resource": "arn:aws:dynamodb:*:${local.account_id}:table/*"
        },
        {
            "Sid": "VisualEditor4",
            "Effect": "Allow",
            "Action": "logs:DescribeLogGroups",
            "Resource": [
              "arn:aws:logs:${var.prod_region}:${local.account_id}:log-group:*"
            ]
        },
        {
            "Sid": "VisualEditor5",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::connect-uat-logos-bucket/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:CreateLogGroup",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents"
            ],
            "Resource": [
              "arn:aws:logs:${var.prod_region}:${local.account_id}:*"
            ]
        },
        {
            "Sid": "FluentBit",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::connect-log-configuration",
                "arn:aws:s3:::connect-log-configuration/*"
            ]
        }
    ]
  })
}

resource "aws_iam_policy" "connect_genesys_execution_role_prod_task_policy" {
  name = "connect-genesys-execution-role-prod-task-policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:ssm:${var.prod_region}:${local.account_id}:parameter/${var.parameter_store_path}/*"
        ]
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:logs:${var.prod_region}:${local.account_id}:*"
        ]
      },
      {
        Action = [
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::connect-log-configuration",
          "arn:aws:s3:::connect-log-configuration/*"
        ]
        Sid = "FluentBit"
      }
    ]
    Version = "2012-10-17"
  })
} 

# IAM Role for ECS Task
resource "aws_iam_role" "genesys_chat_translator_task_role_prod" {
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
    Version = "2012-10-17"
  })
  managed_policy_arns = [
    aws_iam_policy.connect_genesys_prod_ecs_task_policy.arn,
    aws_iam_policy.connect_genesys_execution_role_prod_task_policy.arn
  ]
 name = "genesys-chat-translator-task-role-prod"
}

# IAM Policy for ECS Execution
resource "aws_iam_policy" "connectexecutionroleprodpolicy20_afff5_ab" {
  name = "connect-genesys-execution-policy-prod"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:ssm:${var.prod_region}:${local.account_id}:parameter/${var.parameter_store_path}/*"
        ]
      },
    ]
  })
}

# IAM Role for ECS Execution
resource "aws_iam_role" "genesys_chat_translator_execution_role_prod" {
  name = "connect-genesys-execution-role-prod"
  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
    Version = "2012-10-17"
  })

  inline_policy {
    name = "CloudWatchAccess"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Effect   = "Allow"
          Resource = [
            "arn:aws:logs:${var.prod_region}:${local.account_id}:log-group${var.cloud_watch_group_name}"
        ]
        },
      ]
    })
  }

  inline_policy {
    name = "S3Access"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Sid = "FluentBit"
          Action   = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:PutObjectAcl"
          ]
          Effect   = "Allow"
          Resource = [
            "arn:aws:s3:::connect-log-configuration",
            "arn:aws:s3:::connect-log-configuration/*"
          ]
        },
      ]
    })
  }

  managed_policy_arns = [
    join("", ["arn:", data.aws_partition.current.partition, ":iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]),
    aws_iam_policy.connectexecutionroleprodpolicy20_afff5_ab.arn
  ]
}

# Security Group for ALB
resource "aws_security_group" "lb_security_group" {
  name        = "genesys-chat-translator-lb-prod-sg"
  description = "Security group for genesys-chat-translator ALB"
  vpc_id      = var.vpc_id

  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # egress {
  #   from_port       = 3000
  #   to_port         = 3000
  #   protocol        = "tcp"
  #   cidr_blocks     = ["0.0.0.0/0"]
  # }
}

resource "aws_vpc_security_group_ingress_rule" "lb_allow_http_ipv4" {
  description       = "Allow from anyone on port 80"
  security_group_id = aws_security_group.lb_security_group.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "lb_allow_https_ipv4" {
  description       = "Allow HTTPS traffic"
  security_group_id = aws_security_group.lb_security_group.id
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}
resource "aws_vpc_security_group_egress_rule" "lb_allow_port_3000_ipv4" {
  description       = "Load balancer to target"
  security_group_id = aws_security_group.lb_security_group.id
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000
  cidr_ipv4         = "0.0.0.0/0"
}

# Security Group for ECS Fargate Service
resource "aws_security_group" "ecs_service_security_group" {
  name        = "genesys-chat-translator-ecs-prod-sg"
  description = "Security group for genesys-chat-translator ECS Fargate Service"
  vpc_id      = var.vpc_id

  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # ingress {
  #   from_port                = 3000
  #   to_port                  = 3000
  #   protocol                 = "tcp"
  #   source_security_group_id = aws_security_group.lb_security_group.id
  # }
}

resource "aws_vpc_security_group_ingress_rule" "ecs_allow_port_3000_ipv4" {
  description                  = "ECS Service to Load balancer"
  security_group_id            = aws_security_group.ecs_service_security_group.id
  from_port                    = 3000
  ip_protocol                  = "tcp"
  to_port                      = 3000
  referenced_security_group_id = aws_security_group.lb_security_group.id # Exactly one of these attributes must be configured: [cidr_ipv4,cidr_ipv6,prefix_list_id,referenced_security_group_id]
}

resource "aws_vpc_security_group_egress_rule" "ecs_allow_all_traffic_ipv4" {
  description = "Allow all outbound traffic by default"
  security_group_id = aws_security_group.ecs_service_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_lb" "fargate_service_alb" {
  name               = var.elb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_security_group.id]
  subnets            = var.public_subnets
}

resource "aws_lb_listener" "fargate_http" {
  load_balancer_arn = aws_lb.fargate_service_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "fargate_https" {
  load_balancer_arn = aws_lb.fargate_service_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.elb_certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fargate_service_lb_public_listener_ecs_group.arn
  }
}

resource "aws_lb_target_group" "fargate_service_lb_public_listener_ecs_group" {
  health_check {
    path    = "/"
    matcher = "200,307,401"
  }
  stickiness {
    enabled = false
    type    = "lb_cookie"
  }
  
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

resource "aws_ecs_task_definition" "genesys_chat_translator_task_prod" {
  container_definitions = jsonencode([
    {
      essential = true
      image = "122639376858.dkr.ecr.us-east-1.amazonaws.com/genesys-chat-translator:prod"
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.cloud_watch_group_name
          awslogs-stream-prefix = "genesys-chat-translator-ecs-prod"
          awslogs-region        = "us-east-1"
        }
      }
      name = "web"
      portMappings = [
        {
          containerPort = 3000
          protocol = "tcp"
        }
      ]
    }
  ])
  cpu = "256"
  execution_role_arn = aws_iam_role.genesys_chat_translator_execution_role_prod.arn
  family = var.ecs_task_family_name
  memory = "512"
  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]
  task_role_arn = aws_iam_role.genesys_chat_translator_task_role_prod.arn
}

resource "aws_cloudwatch_log_group" "my_fargate_service_task_defweb_log_group4_a6_c44_e8" {
  name = var.cloud_watch_group_name
  retention_in_days = 365
}

# ECS Fargate Service
resource "aws_ecs_service" "genesys_chat_translator_service_prod" {
  name            = var.ecs_svc_name
  cluster         = aws_ecs_cluster.genesys_chat_translator_cluster_prod.arn
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.genesys_chat_translator_task_prod.arn

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
  desired_count = 2
  enable_ecs_managed_tags = false
  health_check_grace_period_seconds = 60
  
  load_balancer {
    container_name   = "web"
    container_port   = 3000
    target_group_arn = aws_lb_target_group.fargate_service_lb_public_listener_ecs_group.id
  }
  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.ecs_service_security_group.id]
  }
}

resource "aws_appautoscaling_target" "ecs_service_scaling_target" {
  max_capacity = 4
  min_capacity = 2
  resource_id  = join("", ["service/", aws_ecs_cluster.genesys_chat_translator_cluster_prod.name, "/", aws_ecs_service.genesys_chat_translator_service_prod.name])
  role_arn     = "arn:aws:iam::${local.account_id}:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_up_policy" {
  name = "scale_up_policy"
  resource_id = aws_appautoscaling_target.ecs_service_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service_scaling_target.service_namespace

  policy_type = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_appautoscaling_policy" "scale_down_policy" {
  name = "scale_down_policy"
  resource_id = aws_appautoscaling_target.ecs_service_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service_scaling_target.service_namespace

  policy_type = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

output "task_role_arn" {
  value = aws_iam_role.genesys_chat_translator_task_role_prod.arn
}

output "execution_role_arn" {
  value = aws_iam_role.genesys_chat_translator_execution_role_prod.arn
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.genesys_chat_translator_task_prod.arn
}

output "ecs_task_definition_family" {
  value = aws_ecs_task_definition.genesys_chat_translator_task_prod.family
}

output "ecs_task_definition_revision" {
  value = aws_ecs_task_definition.genesys_chat_translator_task_prod.revision
}

output "load_balancer_arn" {
  value = aws_lb.fargate_service_alb.arn
}

output "load_balancer_dns_name" {
  value = aws_lb.fargate_service_alb.dns_name
}

output "load_balancer_url" {
  value = join("", ["http://", aws_lb.fargate_service_alb.dns_name])
}

output "elastic_container_service_name" {
  value = aws_ecs_service.genesys_chat_translator_service_prod.name
}

output "aws_security_group_lb_security_group_id" {
  value = aws_security_group.lb_security_group.id
}

output "aws_security_group_ecs_service_security_group_id" {
  value = aws_security_group.ecs_service_security_group.id
}
