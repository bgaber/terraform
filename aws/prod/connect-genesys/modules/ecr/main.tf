resource "aws_ecr_repository" "connect_genesys" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_arn" {
  value = aws_ecr_repository.connect_genesys.arn
}
