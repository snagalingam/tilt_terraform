# staging
variable "staging_beanstalk_description" {
  default     = "backend deployment for staging"
  description = "description of beanstalk application"
}

variable "staging_domain_name" {
  default     = "api.tiltstaging.dev"
  description = "domain name"
}

variable "staging_main_name" {
  default     = "tilt-stage"
  description = "name used throughout the code"
}

variable "staging_backend_repository" {
  default     = "snagalingam/tilt_backend"
  description = "GitHub repository"
}

variable "staging_backend_branch" {
  default     = "staging"
  description = "branch to pull from Github"
}

variable "staging_deployment_repository" {
  default     = "snagalingam/tilt_backend_staging"
  description = "GitHub repository"
}

variable "staging_deployment_branch" {
  default     = "main"
  description = "branch to pull from Github"
}

variable "staging_pipeline_name" {
  default     = "tilt-stage"
  description = "name of pipeline"
}

# production
variable "beanstalk_description" {
  default     = "backend deployment for staging"
  description = "description of beanstalk application"
}

variable "domain_name" {
  default     = "api.tilt.dev"
  description = "domain name"
}

variable "main_name" {
  default     = "tilt-production"
  description = "name used throughout the code"
}

variable "backend_repository" {
  default     = "snagalingam/tilt_backend"
  description = "GitHub repository"
}

variable "backend_branch" {
  default     = "staging"
  description = "branch to pull from Github"
}

variable "deployment_repository" {
  default     = "snagalingam/tilt_backend_staging"
  description = "GitHub repository"
}

variable "deployment_branch" {
  default     = "main"
  description = "branch to pull from Github"
}

variable "pipeline_name" {
  default     = "tilt-production"
  description = "name of pipeline"
}