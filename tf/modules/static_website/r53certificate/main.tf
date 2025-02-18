# AWS Certificate Manager Certificate for the domain
#
# Note that this requires that the domain is managed by Route53.
# Additionally, this certificate must be created in the us-east-1 region.

# Ensure that the provider is in the us-east-1 region
data "aws_region" "current" {}

locals {
  provider_region = data.aws_region.current.name
  is_provider_east = local.provider_region == "us-east-1"
}

resource "null_resource" "check_region" {
  count = local.is_provider_east ? 0 : 1

  provisioner "local-exec" {
    command = <<EOF
echo "ERROR: The AWS Certificate Manager Certificate must be created in the us-east-1 region. Please pass a provider with the us-east-1 region."
exit 1
EOF
  }
}

# Make certificate and validation for the domain
resource "aws_acm_certificate" "certificate" {
  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  validation_method         = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options :
    dvo.domain_name => dvo
  }

  zone_id = var.hosted_zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [
    for record in aws_route53_record.cert_validation : record.fqdn
  ]
}
