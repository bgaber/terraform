# VERSION 2.1

data "aws_partition" "current" {}

data "aws_caller_identity" "prod" {}

locals {
    account_id = data.aws_caller_identity.prod.account_id
}

resource "aws_ecr_repository" "connect" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_cluster" "my_cluster4_c1_ba579" {
  name = var.ecs_cluster_name
}

resource "aws_iam_policy" "connect_prod_ecs_policy" {
  name = "connect-prod-ecs-policy"

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
                "arn:aws:logs:${var.dr_region}:${local.account_id}:log-group:/aws/lambda/*:log-stream:*",
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
                "arn:aws:logs:${var.dr_region}:${local.account_id}:log-group:/aws/lambda/*",
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
              "arn:aws:logs:${var.prod_region}:${local.account_id}:log-group:*",
              "arn:aws:logs:${var.dr_region}:${local.account_id}:log-group:*"
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
              "arn:aws:logs:${var.prod_region}:${local.account_id}:*",
              "arn:aws:logs:${var.dr_region}:${local.account_id}:*"
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
                "arn:aws:s3:::connect-log-configuration/*",
                "arn:aws:s3:::connect-dr-log-configuration",
                "arn:aws:s3:::connect-dr-log-configuration/*"
            ]
        }
    ]
  })
}

resource "aws_iam_policy" "connectexecutionroleprodtaskpolicy26_b949_e5_f" {
  name = "connect-execution-role-prod-task-policy-2"

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
          "arn:aws:ssm:${var.prod_region}:${local.account_id}:parameter/connect/prod/*",
          "arn:aws:ssm:${var.dr_region}:${local.account_id}:parameter/connect/prod/*"
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
          "arn:aws:logs:${var.prod_region}:${local.account_id}:*",
          "arn:aws:logs:${var.dr_region}:${local.account_id}:*"
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
          "arn:aws:s3:::connect-log-configuration/*",
          "arn:aws:s3:::connect-dr-log-configuration",
          "arn:aws:s3:::connect-dr-log-configuration/*"
        ]
        Sid = "FluentBit"
      }
    ]
    Version = "2012-10-17"
  })
} 

resource "aws_iam_role" "connecttaskrole2_b24_d62_e" {
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
    aws_iam_policy.connect_prod_ecs_policy.arn,
    aws_iam_policy.connectexecutionroleprodtaskpolicy26_b949_e5_f.arn
  ]
  name = "connect-task-role-prod"
}

resource "aws_iam_policy" "connectexecutionroleprodpolicy20_afff5_ab" {
  name = "connect-execution-role-prod-policy-2"

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
          "arn:aws:ssm:${var.prod_region}:${local.account_id}:parameter/connect/prod/*",
          "arn:aws:ssm:${var.dr_region}:${local.account_id}:parameter/connect/prod/*"
        ]
      },
    ]
  })
}

resource "aws_iam_role" "connectexecutionrole50038886" {
  name = "connect-execution-role-prod"
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
            "arn:aws:logs:${var.prod_region}:${local.account_id}:log-group${var.cloud_watch_group_name}",
            "arn:aws:logs:${var.dr_region}:${local.account_id}:log-group${var.cloud_watch_group_name}"
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
            "arn:aws:s3:::connect-log-configuration/*",
            "arn:aws:s3:::connect-dr-log-configuration",
            "arn:aws:s3:::connect-dr-log-configuration/*"
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

resource "aws_security_group" "my_fargate_service_lb_security_group6_fbf16_f1" {
  description = "Automatically created Security Group for ELB connectecsprodMyFargateServiceLBF80271FE"
  # ingress {
  #     cidr_blocks = ["0.0.0.0/0"]
  #     description = "Allow from anyone on port 80"
  #     from_port = 80
  #     protocol = "tcp"
  #     to_port = 80
  # }
  # ingress {
  #     cidr_blocks = ["0.0.0.0/0"]
  #     description = "Allow from anyone on port 443"
  #     from_port = 443
  #     protocol = "tcp"
  #     to_port = 443
  # }
  vpc_id = var.vpc_id
}

resource "aws_security_group" "fargate_service_lb_security_group" {
  description = "Automatically created Security Group for ELB connectecsprodMyFargateServiceLBF80271FE"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "fargate_service_security_group_inbound_http" {
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  description = "Allow from anyone on port 80"
  from_port = 80
  security_group_id = aws_security_group.fargate_service_lb_security_group.id
  to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "fargate_service_security_group_inbound_https" {
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  description = "Allow from anyone on port 443"
  from_port = 443
  security_group_id = aws_security_group.fargate_service_lb_security_group.id
  to_port = 443
}

resource "aws_vpc_security_group_egress_rule" "fargate_service_security_groupfromconnectecsprod_my_fargate_service_lb_security_group" {
  ip_protocol = "tcp"
  description = "Load balancer to target"
  from_port = 3000
  referenced_security_group_id = aws_security_group.fargate_service_security_group.id
  security_group_id = aws_security_group.fargate_service_lb_security_group.id
  to_port = 3000
}

resource "aws_lb" "fargate_service_alb" {
  name               = "connect-lb-prod"
  internal           = false
  load_balancer_type = "application"
  #security_groups    = [aws_security_group.fargate_service_lb_security_group.id]
  security_groups    = [aws_security_group.my_fargate_service_lb_security_group6_fbf16_f1.id]
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
    matcher = "200,307"
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

resource "aws_ecs_task_definition" "fargate_service_task_defn" {
  container_definitions = jsonencode([
    {
      essential = true
      image = "${local.account_id}.dkr.ecr.us-east-1.amazonaws.com/connect:21"
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = var.cloud_watch_group_name
          awslogs-stream-prefix = "connect-ecs-prod"
          awslogs-region = var.prod_region
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
  execution_role_arn = aws_iam_role.connectexecutionrole50038886.arn
  family = var.ecs_task_family_name
  memory = "512"
  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]
  task_role_arn = aws_iam_role.connecttaskrole2_b24_d62_e.arn
}

resource "aws_cloudwatch_log_group" "my_fargate_service_task_defweb_log_group4_a6_c44_e8" {
  name = var.cloud_watch_group_name
  retention_in_days = 365
}

resource "aws_ecs_service" "my_fargate_service_f490_c034" {
  cluster = aws_ecs_cluster.my_cluster4_c1_ba579.arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count = 2
  enable_ecs_managed_tags = false
  health_check_grace_period_seconds = 60
  launch_type = "FARGATE"
  load_balancer {
    container_name   = "web"
    container_port   = 3000
    target_group_arn = aws_lb_target_group.fargate_service_lb_public_listener_ecs_group.id
  }
  network_configuration {
    subnets         = var.private_subnets
    #security_groups = [aws_security_group.fargate_service_security_group.id]
    security_groups = [aws_security_group.my_fargate_service_security_group7016792_a.id]
  }
  name = var.ecs_svc_name
  # task_definition = aws_ecs_task_definition.fargate_service_task_defn.arn
  task_definition = "arn:aws:ecs:us-east-1:122639376858:task-definition/connect-task-prod:107"
}

resource "aws_security_group" "my_fargate_service_security_group7016792_a" {
  description = "connect-ecs-prod/MyFargateService/Service/SecurityGroup"
  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   description = "Allow all outbound traffic by default"
  # }
  vpc_id = var.vpc_id
}

resource "aws_security_group" "fargate_service_security_group" {
  description = "connect-ecs-prod/MyFargateService/Service/SecurityGroup"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "fargate_service_lb_security_group_all_outbound_traffic" {
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
  description = "Allow all outbound traffic by default"
  security_group_id = aws_security_group.fargate_service_security_group.id
}

resource "aws_vpc_security_group_ingress_rule" "fargate_service_lb_security_grouptoconnectecsprod_my_fargate_service_security_group" {
  referenced_security_group_id = aws_security_group.fargate_service_lb_security_group.id
  ip_protocol = "tcp"
  description = "Load balancer to target"
  security_group_id = aws_security_group.fargate_service_security_group.id
  from_port = 3000
  to_port = 3000
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity = 4
  min_capacity = 2
  resource_id  = join("", ["service/", aws_ecs_cluster.my_cluster4_c1_ba579.name, "/", aws_ecs_service.my_fargate_service_f490_c034.name])
  role_arn     = "arn:aws:iam::${local.account_id}:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "connectecsprodMyFargateServiceTaskCountTargetCpuScaling4403099E"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
    target_value       = 50
  }
}

output "ecr_arn" {
  value = aws_ecr_repository.connect.arn
}

output "task_role" {
  value = aws_iam_role.connecttaskrole2_b24_d62_e.arn
}

output "execution_role" {
  value = aws_iam_role.connectexecutionrole50038886.arn
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.fargate_service_task_defn.arn
}

output "ecs_task_definition_family" {
  value = aws_ecs_task_definition.fargate_service_task_defn.family
}

output "ecs_task_definition_revision" {
  value = aws_ecs_task_definition.fargate_service_task_defn.revision
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
  value = aws_ecs_service.my_fargate_service_f490_c034.name
}

output "aws_security_group_my_fargate_service_lb_security_group6_fbf16_f1_id" {
  value = aws_security_group.my_fargate_service_lb_security_group6_fbf16_f1.id
}

output "aws_security_group_fargate_service_lb_security_group_id" {
  value = aws_security_group.fargate_service_lb_security_group.id
}

output "aws_security_group_my_fargate_service_security_group7016792_a_id" {
  value = aws_security_group.my_fargate_service_security_group7016792_a.id
}

output "aws_security_group_fargate_service_security_group_id" {
  value = aws_security_group.fargate_service_security_group.id
}
