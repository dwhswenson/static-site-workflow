locals {
  make_certificate = (var.domain_name != "") && (var.certificate_arn == "")
  do_dns = (var.hosted_zone_id != "")
  site_aliases = (
    (var.domain_name != "") ? (var.force_www ?
      ["www.${var.domain_name}", "${var.domain_name}"] :
      ["${var.domain_name}"]):
    []
  )
}

module "certificate" {
  count = local.make_certificate ? 1 : 0
  source = "./r53certificate"
  domain_name = var.domain_name
  hosted_zone_id = var.hosted_zone_id
  providers = {
    aws = aws.use1
  }
}

# in order of preference: newly-created certificate, passed-in certificate,
# none (use cloudfront's default) -- newly-created only exists if nothing
# was passed in
locals {
  certificate_arn = (
    length(module.certificate) > 0 ? module.certificate[0].certificate_arn :
    (var.certificate_arn != "" ? var.certificate_arn : "")
  )
}

module "bucket" {
  source = "./bucket_and_role"
  bucket_name = var.bucket_name
  oidc_provider_arn = var.github_oidc_provider_arn
  subject_filters = var.subject_filters
  repository = var.repository
  gh_secret_prefix = var.gh_secret_prefix
  read_only_buckets = var.read_only_buckets
}

module "cloudfront" {
  source = "./cloudfront"
  #domain_name = var.domain_name
  aliases = local.site_aliases
  force_www = var.force_www
  workflow_role_name = module.bucket.role_name
  certificate_arn = local.certificate_arn
  s3_bucket = var.bucket_name
  repository = var.repository
  gh_secret_prefix = var.gh_secret_prefix
}

module "dns" {
  count = local.do_dns ? 1 : 0
  source = "./dns"
  domain_names = local.site_aliases
  cloudfront_distribution_name = module.cloudfront.distribution_name
  cloudfront_distribution_hosted_zone = module.cloudfront.distribution_hosted_zone
  hosted_zone_id = var.hosted_zone_id
}

resource "github_actions_variable" "website_url" {
  repository = "${split("/", var.repository)[1]}"
  variable_name = "${var.gh_secret_prefix}_WEBSITE"
  value = "https://${var.domain_name}"
}
