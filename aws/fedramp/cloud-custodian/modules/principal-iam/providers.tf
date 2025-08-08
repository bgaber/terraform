terraform {
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
      version = ">= 17.8.0"
    }
  }
}

# ensure the following GITLAB_TOKEN environment variable has been set:
# export GITLAB_TOKEN="your-personal-access-token"
provider "gitlab" {
  base_url  = "https://gitlab.tecsysrd.cloud/api/v4/"
}