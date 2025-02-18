variable "repository" {
  description = "The name of the repository"
  type        = string
}

variable "default_branch" {
  description = "The default branch of the repository"
  type        = string
}

variable "workflows" {
  description = "The workflows to run"
  type        = list(string)
}
