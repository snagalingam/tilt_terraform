# staging DNS certificate
resource "aws_acm_certificate" "staging_cert" {
  domain_name       = var.staging_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# production DNS certificate
resource "aws_acm_certificate" "production_cert" {
  domain_name       = var.production_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
