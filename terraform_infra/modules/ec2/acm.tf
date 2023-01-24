provider "aws" {
  alias  = "acm_provider"
  region = var.aws_region
}

resource "aws_acm_certificate" "main" {
  domain_name               = "spring-petclinic.${var.domain_name}"
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.main : record.fqdn]
}