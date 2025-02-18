output "distribution_name" {
  value = aws_cloudfront_distribution.distribution.domain_name
}

output "distribution_hosted_zone" {
  value = aws_cloudfront_distribution.distribution.hosted_zone_id
}
