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
  default     = "tilt-staging"
  description = "name of pipeline"
}
