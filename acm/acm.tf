variable "cert_domain" {
  type = string
}

variable "dns_domain" {
  type = string
}

data "aws_route53_zone" "cert_dns_zone" {
  name = var.dns_domain
}

resource "aws_acm_certificate" "acm_cert" {
  domain_name = var.cert_domain
  validation_method = "DNS"
}


resource "aws_route53_record" "validation" {
  name    = tolist(aws_acm_certificate.acm_cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.acm_cert.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.cert_dns_zone.zone_id
  records = [tolist(aws_acm_certificate.acm_cert.domain_validation_options)[0].resource_record_value]
  ttl     = "300"
}

output "cert_arn" {
  value = aws_acm_certificate.acm_cert.arn
}