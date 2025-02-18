module "oidc_claims" {
  source             = "./modules/custom-oidc-subject"
  repository         = var.repository
  default_branch     = var.default_branch
  include_claim_keys = ["repo", "context", "job_workflow_ref"]
}

module "prod_oidc_subjects" {
  source         = "./modules/github-oidc-claim-match"
  repository     = var.repository
  default_branch = var.default_branch
  workflows      = var.prod_workflows
}

module "prod_site" {
  source                   = "./modules/static_website"
  hosted_zone_id           = var.hosted_zone_id
  certificate_arn          = var.prod_certificate_arn
  bucket_name              = var.bucket_name
  github_oidc_provider_arn = var.github_oidc_provider_arn
  domain_name              = var.domain_name
  force_www                = var.force_www
  subject_filters          = module.prod_oidc_subjects.subject_filters
  repository               = var.repository
  gh_secret_prefix         = "PROD"
  providers = {
    aws      = aws
    aws.use1 = aws.use1
  }
}


module "staging_oidc_subjects" {
  source         = "./modules/github-oidc-claim-match"
  repository     = var.repository
  default_branch = var.default_branch
  workflows      = var.staging_workflows
}

module "staging_site" {
  source                   = "./modules/static_website"
  hosted_zone_id           = var.hosted_zone_id
  certificate_arn          = var.staging_certificate_arn
  bucket_name              = "staging-${var.bucket_name}"
  github_oidc_provider_arn = var.github_oidc_provider_arn
  domain_name              = "staging.${var.domain_name}"
  force_www                = false
  subject_filters          = module.staging_oidc_subjects.subject_filters
  repository               = var.repository
  gh_secret_prefix         = "STAGING"
  read_only_buckets        = [module.prod_site.bucket_name]
  providers = {
    aws      = aws
    aws.use1 = aws.use1
  }
}
