resource "aws_acm_certificate" "go4connect" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = var.alternate_names

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "go4connect" {
  #provider     = aws.r53_role
  name         = "go4connect.com"
  private_zone = false
}

resource "aws_route53_record" "go4connect" {
  #provider = aws.r53_role
  for_each = {
    for dvo in aws_acm_certificate.go4connect.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.go4connect.zone_id
}

resource "aws_acm_certificate_validation" "go4connect" {
  certificate_arn         = aws_acm_certificate.go4connect.arn
  validation_record_fqdns = [for record in aws_route53_record.go4connect : record.fqdn]
}

output "acm_certificate_id" {
  value = aws_acm_certificate.go4connect.id
}

output "acm_certificate_arn" {
  value = aws_acm_certificate.go4connect.arn
}