resource "aws_ecr_repository" "tilt_backend_staging" {
  name                 = "tilt_backend_staging"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "tilt_backend_production" {
  name                 = "tilt_backend_production"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}