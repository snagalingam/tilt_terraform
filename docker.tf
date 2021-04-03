# staging Elastic Container Repository for Docker images
resource "aws_ecr_repository" "tilt_backend_staging" {
  name                 = var.staging_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# production Elastic Container Repository for Docker images
resource "aws_ecr_repository" "tilt_backend_production" {
  name                 = var.production_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
