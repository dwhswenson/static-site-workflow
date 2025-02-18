variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "read_only_buckets" {
  description = "List of read-only bucket names"
  type        = list(string)
  default     = []
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC Provider"
  type        = string
}

variable "repository" {
  description = "GitHub repository name"
  type        = string
}

variable "subject_filters" {
  description = "OIDC subject filter for allowed workflows"
  type        = list(string)
}

variable "gh_secret_prefix" {
  description = "Prefix to use for name of secrets in GitHub Actions"
  type        = string
  default     = "AWS_PROD"
}
