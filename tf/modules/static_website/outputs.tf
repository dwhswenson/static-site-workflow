output "bucket_name" {
  value = var.bucket_name
}

output "cloudfront_distribution_name" {
  value = module.cloudfront.distribution_name
}

# TODO: we need to add a lot more outputs here!
