variable "domain_name" {
  description = "The domain name for the Route 53 hosted zone"
  type        = string
  default     = ""
}

variable "read_only_buckets" {
  description = "List of read-only bucket names"
  type        = list(string)
  default     = []
}

variable "hosted_zone_id" {
  description = "The ID of the Route 53 hosted zone"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "github_oidc_provider_arn" {
  description = "The ARN of the GitHub OIDC provider"
  type        = string
}

variable "repository" {
  description = "The name of the GitHub repository"
  type        = string
}

variable "subject_filters" {
  description = "The OIDC filters for the GitHub Actions workflows"
  type        = list(string)
}

variable "gh_secret_prefix" {
  description = "The prefix for the GitHub secret"
  type        = string
}

variable "force_www" {
  description = "Whether to force www or not"
  type        = bool
  default     = true
}

variable "certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
  default     = ""
}
