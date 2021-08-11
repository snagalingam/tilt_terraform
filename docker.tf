# staging Elastic Container Repository for Docker images
resource "aws_ecr_repository" "tilt_backend" {
  name                 = var.cluster_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}


