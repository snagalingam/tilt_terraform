# set the region
provider "aws" {
  region = "us-east-2"
}

# github connection
# using an already existing github connection
# resource "aws_codestarconnections_connection" "github" {
#   name          = "github"
#   provider_type = "GitHub"
# }
