data "github_repository" "repo" {
  full_name = var.repository
}

resource "github_actions_repository_oidc_subject_claim_customization_template" "this" {
  repository = data.github_repository.repo.name
  use_default = false
  include_claim_keys = ["repo", "context", "job_workflow_ref"]
}
