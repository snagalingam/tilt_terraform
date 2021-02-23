# staging
variable "beanstalk_description" {
  default     = "backend deployment for staging"
  description = "description of beanstalk application"
}

variable "domain_name" {
  default     = "api.tiltstaging.dev"
  description = "domain name"
}

variable "main_name" {
  default     = "tilt-staging"
  description = "name used throughout the code"
}

# production
# variable "beanstalk_description" {
#   default     = "backend deployment for production"
#   description = "description of beanstalk application"
# }
#
# variable "domain_name" {
#   default     = "api.tiltaccess.com"
#   description = "domain name"
# }
#
# variable "main_name" {
#   default     = "tilt-production"
#   description = "name used throughout the code"
# }
