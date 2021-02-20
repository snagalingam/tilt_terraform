variable "application_name" {
  default     = "tilt-staging-build"
  description = "application name"
}

variable "webhook_secret" {
  default     = ""
  description = "token for github"
}
