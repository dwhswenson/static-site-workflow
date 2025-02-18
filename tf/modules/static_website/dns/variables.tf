variable "hosted_zone_id" {
  description = "The Route 53 hosted zone ID"
  type        = string
}

variable "domain_names" {
  description = "The domain names to create the certificate for"
  type        = list(string)
}

variable "cloudfront_distribution_name" {
  description = "The CloudFront distribution name"
  type        = string
}

variable "cloudfront_distribution_hosted_zone" {
  description = "The CloudFront distribution hosted zone"
  type        = string
}
