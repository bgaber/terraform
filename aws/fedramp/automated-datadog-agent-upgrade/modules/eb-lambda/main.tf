data "aws_caller_identity" "current" {}
locals {
    account_id  = data.aws_caller_identity.current.account_id
}

# S3 Bucket for CSV Storage and Athena Query Results
resource "aws_s3_bucket" "athena_source_bucket" {
  bucket = var.s3_source_bucket_name
  force_destroy = true
}

# S3 Bucket Object for the CSV file (You need to upload the actual CSV manually)
resource "aws_s3_object" "csv_file" {
  bucket = aws_s3_bucket.athena_source_bucket.id
  key    = "${var.athena_prefix}/${var.athena_csv_key}"
  source = "${path.module}/artifacts/${var.athena_csv_key}"  # Replace with actual CSV path
  content_type = "text/csv"
}

# S3 Bucket for Athena Query Results
resource "aws_s3_bucket" "athena_results_bucket" {
  bucket = var.s3_results_bucket_name
  force_destroy = true
}

# Glue Database for Athena
resource "aws_glue_catalog_database" "athena_db" {
  name = var.database_name
}

# Glue Table for Athena Querying
resource "aws_glue_catalog_table" "athena_table" {
  name          = var.athena_table
  database_name = var.database_name
  table_type    = "EXTERNAL_TABLE"

  depends_on = [aws_glue_catalog_database.athena_db] # Ensure database is created first

  parameters = {
    "skip.header.line.count" = "1"
  }

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.athena_source_bucket.id}/data/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "OpenCSVSerde"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"
      parameters = {
        "separatorChar" = ","
        "quoteChar"     = "\""
      }
    }

    columns {
      name = "Version"
      type = "string"
    }

    columns {
      name = "Approved"
      type = "string"
    }
  }
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# IAM Policy for Athena, Glue, S3, SSM, SNS and EC2 IAM Access
resource "aws_iam_policy" "lambda_policy" {
  name        = var.lambda_policy_name
  description = "Grants Lambda access to Athena and S3 query results"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["sts:AssumeRole"],
        Resource = [
          "arn:aws:iam::438979369891:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::686255941416:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::311141548321:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::528757785295:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::054037137415:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::202533508444:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::816069130447:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::104299473261:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::445567083790:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::548813917035:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::897722679597:role/${var.lambda_iam_assume_role_name}",
          "arn:aws:iam::195665324256:role/${var.lambda_iam_assume_role_name}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "athena:StartQueryExecution",
          "athena:GetQueryExecution",
          "athena:GetQueryResults"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "glue:GetDatabase",
          "glue:GetTable",
          "glue:GetPartition"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:ListMultipartUploadParts",
          "s3:AbortMultipartUpload",
          "s3:CreateBucket",
          "s3:PutObject",
          "s3:PutBucketPublicAccessBlock"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.athena_source_bucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.athena_source_bucket.id}/*",
          "arn:aws:s3:::${aws_s3_bucket.athena_results_bucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.athena_results_bucket.id}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:ListCommandInvocations",
          "ssm:GetCommandInvocation",
          "ssm:DescribeInstanceInformation",
          "ssm:DescribeDocument",
          "ssm:GetParameter"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "attach_lambda_policy_name" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
# IAM Policy for Lambda Logging
resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda-logging-${var.lambda_logging_policy_name}"
  path        = "/"
  description = "Allows Lambda to write logs to CloudWatch"
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
              "arn:aws:logs:us-east-1:${local.account_id}:log-group:/aws/lambda/${var.automated_agent_installation_lambda_name}:*",
            ]
        },
        {
            Sid: "ParameterStoreAccess",
            Effect: "Allow",
            Action: [
                "ssm:GetParameter",
                "ssm:PutParameter"
            ],
            Resource: [
              "arn:aws:ssm:us-east-1:${local.account_id}:parameter/*",
            ]
        }
    ]
  })
}

# Attach Logging Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "attach_logging" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
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
  name               = "role_for_lambda_${var.automated_agent_installation_lambda_name}"
  assume_role_policy = data.aws_iam_policy_document.trusted_entity.json
}

# data "aws_ssm_parameter" "datadog_api" {
#   name = "DATADOG_API_KEY"
# }

# data "aws_ssm_parameter" "datadog_app" {
#   name = "DATADOG_APP_KEY"
# }

data "archive_file" "python_lambda_package" {  
  type = "zip"  
  source_file = "${path.module}/code/athena_lambda_function.py" 
  output_path = "${path.module}/artifacts/${var.athena_lambda_archive}"
}

# Create an S3 bucket for Lambda layers (if not already created)
resource "aws_s3_bucket" "lambda_layer_bucket" {
  bucket = "${var.project_name}-lambda-layers"
}

# Upload the layer ZIP file to S3
resource "aws_s3_object" "lambda_layer_zip" {
  bucket = aws_s3_bucket.lambda_layer_bucket.id
  key    = "layers/requests-layer.zip"
  source = "${path.module}/artifacts/requests-layer.zip"  # Ensure the ZIP file exists locally
}

# Create Lambda Layer for requests module
resource "aws_lambda_layer_version" "requests_layer" {
  layer_name          = "requests-layer"
  compatible_runtimes = ["python3.8", "python3.9", "python3.10", "python3.12"]
  s3_bucket          = aws_s3_bucket.lambda_layer_bucket.id
  s3_key             = aws_s3_object.lambda_layer_zip.key
}

# Lambda Function for Querying Athena
resource "aws_lambda_function" "athena_lambda" {
  function_name = var.automated_agent_installation_lambda_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "athena_lambda_function.lambda_handler"

  filename = "${data.archive_file.python_lambda_package.output_path}"
  source_code_hash = "${data.archive_file.python_lambda_package.output_base64sha256}"

  memory_size = 512
  runtime = "python3.12"
  timeout = 240

  # Attach the Layer
  layers = [aws_lambda_layer_version.requests_layer.arn]

  environment {
    variables = {
      DATABASE_NAME             = var.database_name
      TABLE_NAME                = var.athena_table
      S3_OUTPUT                 = "s3://${aws_s3_bucket.athena_results_bucket.id}/"
      SNS_TOPIC_ARN             = var.sns_topic_arn
      S3_BUCKET                 = var.s3_source_bucket_name
      S3_KEY                    = "${var.athena_prefix}/${var.athena_csv_key}"
      LINUX_SSM_DOCUMENT_NAME   = var.linux_ssm_document_arn
      WINDOWS_SSM_DOCUMENT_NAME = var.windows_ssm_document_arn
      MUTE_ENABLED              = false
      MUTE_DURATION_IN_SECS     = 20
    }
  }
  
# https://spacelift.io/blog/terraform-ignore-changes
  # lifecycle {
  #   ignore_changes = [
  #     environment,
  #   ]
  # }
}

resource "aws_iam_role" "scheduler" {
  name = "${var.schedule_name}-scheduler-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = ["scheduler.amazonaws.com"]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "scheduler" {
  policy_arn = aws_iam_policy.scheduler.arn
  role       = aws_iam_role.scheduler.name
}

resource "aws_iam_policy" "scheduler" {
  name = "${var.schedule_name}-scheduler-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # allow scheduler to execute the task
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = [
            "arn:aws:lambda:us-east-1:${local.account_id}:function:${var.automated_agent_installation_lambda_name}:*",
            aws_lambda_function.athena_lambda.arn
        ]
      }
    ]
  })
}

resource "aws_scheduler_schedule" "poll_agent_version" {
  name        = var.schedule_name
  description = var.schedule_description
  group_name  = "default"
  #start_date  = "2025-06-18T13:00:00Z"
  schedule_expression_timezone = "America/Toronto"

  flexible_time_window {
    mode = "OFF"
  }

  # schedule_expression = "cron(0 7 ? * 7 *)"  # Runs at 7 AM UTC → 3 AM EDT during Daylight time (Mar - Nov) and 2 am EST for Standard Time (Nov–Mar)
  schedule_expression = "cron(0 3 ? * 7#2 *)" # Runs second Saturday of each month at 3 AM EDT

  target {
    arn      = aws_lambda_function.athena_lambda.arn
    # role that allows scheduler to start the task
    role_arn = aws_iam_role.scheduler.arn
  }
}


output "aws_s3_source_bucket_arn" {
  value = aws_s3_bucket.athena_source_bucket.arn
}

output "aws_s3_results_bucket_arn" {
  value = aws_s3_bucket.athena_results_bucket.arn
}

output "aws_lambda_function_arn" {
  value = aws_lambda_function.athena_lambda.arn
}

output "aws_lambda_function_invoke_arn" {
  value = aws_lambda_function.athena_lambda.invoke_arn
}

output "lambda_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_role.arn
}

output "aws_scheduler_schedule_id" {
  value = aws_scheduler_schedule.poll_agent_version.id
}

output "aws_scheduler_schedule_arn" {
  value = aws_scheduler_schedule.poll_agent_version.arn
}