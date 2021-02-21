variable "application_name" {
  default     = "tilt-staging"
  description = "application name"
}

variable "application_description" {
  default     = "backend deployment for staging"
  description = "description of application"
}

variable "application_environment" {
  default     = "tilt-staging"
  description = "environment name"
}

variable "region" {
  default     = "us-east-2"
  description = "Defines where your app should be deployed"
}
