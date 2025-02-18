locals {
  workflow_claims = [
    for filt in var.workflows: join(":", [
      "repo:${var.repository}",
      "*",
      # TODO: limit to default branch
      "job_workflow_ref:${var.repository}/.github/workflows/${filt}@refs/heads/${var.default_branch}"
    ])
  ]
}


