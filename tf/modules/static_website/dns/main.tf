resource "aws_route53_record" "cloudfront_domains" {
  for_each = toset(var.domain_names)

  zone_id = var.hosted_zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = var.cloudfront_distribution_name
    zone_id                = var.cloudfront_distribution_hosted_zone
    evaluate_target_health = false
  }
}
