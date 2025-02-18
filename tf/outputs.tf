output "staging_site_cloudfront_distribution_name" {
  value = module.staging_site.cloudfront_distribution_name
}

output "prod_site_cloudfront_distribution_name" {
  value = module.prod_site.cloudfront_distribution_name
}
