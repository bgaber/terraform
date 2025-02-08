resource "aws_route53_record" "connect_genesys_prod" {
  zone_id  = var.hosted_zone_id
  name     = var.prod_record_name
  ttl      = 300
  type     = "CNAME"
  records  = [var.prod_record_value]
}

resource "aws_route53_record" "connect_genesys_uat" {
  zone_id  = var.hosted_zone_id
  name     = var.uat_record_name
  ttl      = 300
  type     = "CNAME"
  records  = [var.uat_record_value]
}

output "connect_genesys_prod_route53_record_name" {
  value = aws_route53_record.connect_genesys_prod.name
}

output "connect_genesys_prod_route53_record_fqdn" {
  value = aws_route53_record.connect_genesys_prod.fqdn
}

output "connect_genesys_uat_route53_record_name" {
  value = aws_route53_record.connect_genesys_uat.name
}

output "connect_genesys_uat_route53_record_fqdn" {
  value = aws_route53_record.connect_genesys_uat.fqdn
}