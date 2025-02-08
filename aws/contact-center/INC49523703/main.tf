module "s3" {
  source = "./modules/s3"
}

module "bitbucket_user" {
  source = "./modules/bitbucket_user"

  s3_bucket_name = module.s3.s3_bucket_id
}

module "cloudfront" {
  source = "./modules/cloudfront"

  alternate_domain_name          = module.s3.s3_bucket_id
  s3_bucket_regional_domain_name = module.s3.s3_bucket_regional_domain_name
  s3_bucket_arn                  = module.s3.s3_bucket_arn
  s3_bucket_name                 = module.s3.s3_bucket_id
}

module "route53" {
  source = "./modules/route53"

  cloudfront_domain_name = module.cloudfront.aws_cloudfront_distribution_domain_name
}