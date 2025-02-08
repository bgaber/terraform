resource "aws_iam_user" "bitbucket_user" {
  name = var.iam_user_name
}

resource "aws_iam_policy" "elastic" {
  name = "elastic-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # allow scheduler to execute the task
        Effect = "Allow",
        Action = [
          "ce:GetCostAndUsage",
          "cloudwatch:GetMetricData",
          "cloudwatch:ListMetrics",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "iam:ListAccountAliases",
          "logs:DescribeLogGroups",
          "logs:FilterLogEvents",
          "organizations:ListAccounts",
          "rds:DescribeDBInstances",
          "rds:ListTagsForResource",
          "s3:GetObject",
          "sns:ListTopics",
          "sqs:ChangeMessageVisibility",
          "sqs:DeleteMessage",
          "sqs:ListQueues",
          "sqs:ReceiveMessage",
          "sts:AssumeRole",
          "sts:GetCallerIdentity",
          "tag:GetResources"
        ]
        Resource = "*",
        Sid = "ElasticAccess"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "elastic" {
  policy_arn = aws_iam_policy.elastic.arn
  user       = aws_iam_user.bitbucket_user.name
}