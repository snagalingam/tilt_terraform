variable "backend_repository" {
  default     = "snagalingam/tilt_backend"
  description = "GitHub repository"
}

variable "backend_branch" {
  default     = "feature/update-deployment"
  description = "branch to pull from Github"
}

variable "beanstalk_application" {
  default     = "tilt-staging"
  description = "beanstalk application for deployment"
}

variable "beanstalk_environment" {
  default     = "tilt-staging"
  description = "beanstalk environment for deployment"
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
  default     = "tilt-staging-build"
  description = "name of pipeline"
}
