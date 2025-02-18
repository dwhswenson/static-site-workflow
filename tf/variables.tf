variable "bucket_name" {
  description = "The name of the production bucket"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the CloudFront distribution"
  type        = string
}

variable "hosted_zone_id" {
  description = "The Route 53 hosted zone ID for the domain. Use empty string if not using Route 53"
  type        = string
}

variable "github_oidc_provider_arn" {
  description = "The ARN of the GitHub OIDC provider"
  type        = string
}

variable "repository" {
  description = "The GitHub repository name"
  type        = string
}

variable "default_branch" {
  description = "The default branch of the GitHub repository"
  type        = string
  default     = "main"
}

variable "prod_workflows" {
  description = "The filter for the GitHub Actions workflow"
  type        = list(string)
  default     = ["upload-prod.yaml"]
}

variable "staging_workflows" {
  description = "The filter for the GitHub Actions workflow"
  type        = list(string)
  default     = ["upload-staging.yaml", "cleanup-staging.yaml"]
}

variable "prod_certificate_arn" {
  description = "The ARN of the ACM certificate for the production domain; if blank, one will be created for you"
  type        = string
  default     = ""
}

variable "staging_certificate_arn" {
  description = "The ARN of the ACM certificate for the staging domain; if blank, one will be created for you"
  type        = string
  default     = ""
}

variable "force_www" {
  description = "Force the domain to use www"
  type        = bool
  default     = true
}
