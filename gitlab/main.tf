resource "gitlab_project_variable" "aws_region" {
  project   = "23009"
  key       = "AWS_REGIONa"
  value     = "us-east-2"
  masked    = false
  protected = false
}