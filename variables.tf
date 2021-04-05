################################################################################
# General Variables
################################################################################
variable "aws_github_connection" {
  default     = "arn:aws:codestar-connections:us-east-2:614818178581:connection/55bda5c3-35a6-4bd4-9886-b342a185a1dc"
  description = "AWS Connection to Github via Codestar"
}

variable "backend_repository" {
  default     = "snagalingam/tilt_backend"
  description = "GitHub repository for backend code"
}

################################################################################
# Staging Variables
################################################################################
variable "staging_backend_branch" {
  default     = "terraform"
  description = "staging branch"
}

variable "staging_beanstalk_description" {
  default     = "backend deployment for staging"
  description = "description of beanstalk application"
}

variable "staging_deployment_branch" {
  default     = "terraform"
  description = "branch to pull from Github"
}

variable "staging_deployment_repository" {
  default     = "snagalingam/tilt_backend_staging"
  description = "GitHub repository for deployment code"
}

variable "staging_domain_name" {
  default     = "api.tiltstaging.dev"
  description = "staging domain name"
}

variable "staging_name" {
  default     = "tilt-staging"
  description = "name of staging pipeline"
}

################################################################################
# Production Variables
################################################################################
variable "production_backend_branch" {
  default     = "staging"
  description = "branch to pull from Github"
}

variable "production_beanstalk_description" {
  default     = "backend deployment for production"
  description = "description of beanstalk application"
}

variable "production_deployment_branch" {
  default     = "main"
  description = "branch to pull from Github"
}

variable "production_deployment_repository" {
  default     = "snagalingam/tilt_backend_staging"
  description = "GitHub repository for production"
}

variable "production_domain_name" {
  default     = "api.tiltacccess.com"
  description = "production domain name"
}

variable "production_name" {
  default     = "tilt-production"
  description = "name of production pipeline"
}
