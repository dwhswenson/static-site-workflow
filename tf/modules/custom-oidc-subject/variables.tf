variable "repository" {
  description = "The name of the repository"
  type        = string
}

variable "default_branch" {
  description = "The default branch of the repository"
  type        = string
}

variable "include_claim_keys" {
  description = "The keys of the claims to include in the token"
  type        = list(string)
  default     = ["repo", "context", "job_workflow_ref"]
}
