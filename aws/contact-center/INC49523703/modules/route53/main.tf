resource "aws_route53_record" "prod_chat" {
  zone_id  = var.hosted_zone_id
  name     = "chat.compucomsupport.com"
  ttl      = 300
  type     = "CNAME"
  records = [var.cloudfront_domain_name]
}

resource "aws_route53_record" "uat_chat" {
  zone_id  = var.hosted_zone_id
  name     = "chatuat.compucomsupport.com"
  ttl      = 300
  type     = "CNAME"
  records = ["d2l0s4eodxw5v3.cloudfront.net"]
}

output "prod_route53_record_name" {
  value = aws_route53_record.prod_chat.name
}

output "prod_route53_record_fqdn" {
  value = aws_route53_record.prod_chat.fqdn
}

output "uat_route53_record_name" {
  value = aws_route53_record.uat_chat.name
}

output "uat_route53_record_fqdn" {
  value = aws_route53_record.uat_chat.fqdn
}