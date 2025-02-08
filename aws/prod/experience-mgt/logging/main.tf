module "s3" {
  source = "./modules/s3"
}

module "kinesis" {
  source = "./modules/kinesis"
  s3_bucket_name = module.s3.s3_source_bucket_name
}

output "s3_error_bucket_name" {
  value = module.s3.s3_error_bucket_name
}
output "s3_error_bucket_arn" {
  value = module.s3.s3_error_bucket_arn
}

output "s3_logs_bucket_name" {
  value = module.s3.s3_logs_bucket_name
}

output "s3_logs_bucket_arn" {
  value = module.s3.s3_logs_bucket_arn
}

output "s3_source_bucket_name" {
  value = module.s3.s3_source_bucket_name
}

output "s3_source_bucket_arn" {
  value = module.s3.s3_source_bucket_arn
}

output "firehose_role_arn" {
  value = module.kinesis.firehose_role_arn
}

output "cloudwatch_role_arn" {
  value = module.kinesis.cloudwatch_role_arn
}

output "kinesis_firehoses_arn" {
  value = module.kinesis.kinesis_firehoses_arn
}