data "aws_bedrock_foundation_model" "digital_assistant" {
  model_id = "amazon.titan-text-express-v1"
}

resource "aws_bedrock_custom_model" "digital_assistant" {
  custom_model_name     = var.custom_model_name
  job_name              = var.job_name
  base_model_identifier = data.aws_bedrock_foundation_model.digital_assistant.model_arn
  role_arn              = aws_iam_role.digital_assistant.arn

  hyperparameters = {
    "epochCount"              = "1"
    "batchSize"               = "1"
    "learningRate"            = "0.005"
    "learningRateWarmupSteps" = "0"
  }

  output_data_config {
    s3_uri = "s3://${aws_s3_bucket.output.id}/data/"
  }

  training_data_config {
    s3_uri = "s3://${aws_s3_bucket.training.id}/data/train.jsonl"
  }
}

output "bedrock_custom_model_arn" {
  value = aws_bedrock_custom_model.digital_assistant.custom_model_arn
}

output "bedrock_custom_job_arn" {
  value = aws_bedrock_custom_model.digital_assistant.job_arn
}
