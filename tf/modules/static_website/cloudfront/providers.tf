terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    github = {
      source = "integrations/github"
      version = "~> 6.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}


