# S3 Bucket for CSV Storage and Athena Query Results
resource "aws_s3_bucket" "athena_source_bucket" {
  bucket = var.s3_source_bucket_name
  force_destroy = true
}

# S3 Bucket Object for the CSV file (You need to upload the actual CSV manually)
resource "aws_s3_object" "csv_file" {
  bucket = aws_s3_bucket.athena_source_bucket.id
  key    = var.athena_csv_key
  source = "./versions.csv"  # Replace with actual CSV path
  content_type = "text/csv"
}

# S3 Bucket for Athena Query Results
resource "aws_s3_bucket" "athena_results_bucket" {
  bucket = var.s3_results_bucket_name
  force_destroy = true
}

# Glue Database for Athena
resource "aws_glue_catalog_database" "athena_db" {
  name = var.dataabase_name
}

# Glue Table for Athena Querying
resource "aws_glue_catalog_table" "athena_table" {
  name          = var.athena_table
  database_name = var.dataabase_name
  table_type    = "EXTERNAL_TABLE"

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
  name = var.athena_lambda_role

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

# IAM Policy for Athena and S3 Access
resource "aws_iam_policy" "athena_s3_policy" {
  name        = var.athena_s3_policy
  description = "Grants Lambda access to Athena and S3 query results"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
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
      }
    ]
  })
}

# Attach Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "attach_athena_s3_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.athena_s3_policy.arn
}

# IAM Policy for Lambda Logging
resource "aws_iam_policy" "lambda_logging" {
  name        = var.lambda_logging_policy_name
  description = "Allows Lambda to write logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "*"
    }]
  })
}

# Attach Logging Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "attach_logging" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_sns_topic" "noc_notification" {
  name = var.sns_topic
}

# Lambda Function for Querying Athena
resource "aws_lambda_function" "athena_lambda" {
  function_name = var.athena_lambda_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "athena_lambda_function.lambda_handler"

  filename = var.athena_lambda_archive  # Ensure this is a zipped Python script
  source_code_hash = filebase64sha256("${var.athena_lambda_archive}")  # Ensures Terraform detects changes

  memory_size = 512
  runtime = "python3.12"
  timeout = 60

  environment {
    variables = {
      DATABASE_NAME = var.dataabase_name
      TABLE_NAME    = var.athena_table
      S3_OUTPUT     = "s3://${aws_s3_bucket.athena_results_bucket.id}/"
      SNS_TOPIC_ARN = aws_sns_topic.noc_notification.arn
      S3_BUCKET     = var.s3_source_bucket_name
      S3_KEY        = var.athena_csv_key
    }
  }
  
# https://spacelift.io/blog/terraform-ignore-changes
  lifecycle {
    ignore_changes = [
      environment,
    ]
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

output "aws_sns_arn" {
  value = aws_sns_topic.noc_notification.arn
}