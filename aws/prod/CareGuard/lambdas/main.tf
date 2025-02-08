data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id

    # Use same map in both resources
  attributes_map = { 
    for attribute in var.lambda_attributes : 
    attribute.name => attribute 
  }
}

data "aws_iam_policy_document" "trusted_entity" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role_for_lambda" {
  for_each = local.attributes_map
  name               = "role_for_lambda_${each.value.name}"
  assume_role_policy = data.aws_iam_policy_document.trusted_entity.json
}

resource "aws_lambda_function" "careguard" {
  for_each      = local.attributes_map
  function_name = each.value.name
  description   = each.value.description
  role          = aws_iam_role.role_for_lambda[each.key].arn
  handler       = "index.handler"

  s3_bucket = var.s3_bucket
  s3_key    = each.value.lambda_deployment_pkg

  memory_size = 512
  runtime = each.value.runtime
  timeout = 240

  environment {
    variables = {
      DB_NAME      = ""
      RDS_HOSTNAME = ""
      RDS_PASSWORD = ""
      RDS_PORT     = "3306"
      RDS_USERNAME = ""
    }
  }

  vpc_config {
    subnet_ids         = var.private_subnets
    security_group_ids = var.security_groups
  }

# https://spacelift.io/blog/terraform-ignore-changes
  lifecycle {
    ignore_changes = [
      environment,
    ]
  }
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_basic_execution_role" {
  #for_each = {for i, v in var.lambda_attributes:  i => v}
  for_each    = local.attributes_map
  name        = "lambda-logging-${each.value.name}"
  path        = "/"
  description = "IAM policy for logging from ${each.value.name}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement: [
        {
            Sid: "CreateLogGroup",
            Effect: "Allow",
            Action: "logs:CreateLogGroup",
            Resource: [
              "arn:aws:logs:us-east-1:${local.account_id}:*",
            ]
        },
        {
            Sid: "CloudWatchLambda",
            Effect: "Allow",
            Action: [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            Resource: [
              "arn:aws:logs:us-east-1:${local.account_id}:log-group:/aws/lambda/${each.value.name}:*",
            ]
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_role" {
  #for_each = {for i, v in var.lambda_attributes:  i => v}
  for_each   = local.attributes_map
  role       = aws_iam_role.role_for_lambda[each.key].name
  policy_arn = aws_iam_policy.lambda_basic_execution_role[each.key].arn
}

# Lambda VPC Access
resource "aws_iam_policy" "lambda_vpc_access_execution_role" {
  for_each    = local.attributes_map
  name        = "lambda-vpc-access-${each.value.name}"
  path        = "/"
  description = "IAM policy for VPC Access from ${each.value.name}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement: [
        {
            Sid: "NetworkInterfacePermissions",
            Effect: "Allow",
            Action: [
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeNetworkInterfaces"
            ],
            Resource: "*"
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access_execution_role" {
  for_each   = local.attributes_map
  role       = aws_iam_role.role_for_lambda[each.key].name
  policy_arn = aws_iam_policy.lambda_vpc_access_execution_role[each.key].arn
}

output "role_for_lambda_name" {
  value = values(aws_iam_role.role_for_lambda)[*].name
}

output "role_for_lambda_id" {
  value = values(aws_iam_role.role_for_lambda)[*].id
}

output "role_for_lambda_arn" {
  value = values(aws_iam_role.role_for_lambda)[*].arn
}

output "lambda_basic_execution_role_policy_id" {
  value = values(aws_iam_policy.lambda_basic_execution_role)[*].id
}

output "lambda_basic_execution_role_policy_arn" {
  value = values(aws_iam_policy.lambda_basic_execution_role)[*].arn
}

output "vpc_access_execution_role_policy_id" {
  value = values(aws_iam_policy.lambda_vpc_access_execution_role)[*].id
}

output "vpc_access_execution_role_policy_arn" {
  value = values(aws_iam_policy.lambda_vpc_access_execution_role)[*].arn
}

output "aws_lambda_function_arn" {
  value = values(aws_lambda_function.careguard)[*].arn
}