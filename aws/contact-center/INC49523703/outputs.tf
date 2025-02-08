output "s3_bucket_id" {
  value = module.s3.s3_bucket_id
}

output "s3_bucket_arn" {
  value = module.s3.s3_bucket_arn
}

output "s3_website_domain" {
  value = module.s3.s3_website_domain
}

output "s3_website_endpoint" {
  value = module.s3.s3_website_endpoint
}

output "bitbucket_user_arn" {
  value = module.bitbucket_user.bitbucket_user_arn
}

output "aws_cloudfront_distribution_id" {
  value = module.cloudfront.aws_cloudfront_distribution_id
}

output "aws_cloudfront_distribution_arn" {
  value = module.cloudfront.aws_cloudfront_distribution_arn
}

output "aws_cloudfront_distribution_domain_name" {
  value = module.cloudfront.aws_cloudfront_distribution_domain_name
}

output "aws_cloudfront_distribution_hosted_zone_id" {
  value = module.cloudfront.aws_cloudfront_distribution_hosted_zone_id
}

output "prod_route53_record_name" {
  value = module.route53.prod_route53_record_name
}

output "prod_route53_record_fqdn" {
  value = module.route53.prod_route53_record_fqdn
}

output "uat_route53_record_name" {
  value = module.route53.uat_route53_record_name
}

output "uat_route53_record_fqdn" {
  value = module.route53.uat_route53_record_fqdn
}