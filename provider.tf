# set the region
provider "aws" {
  region = "us-east-2"
  access_key = "AKIAY6JQE4YK6XRSJK6P"
  secret_key = "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"
}

# github connection
resource "aws_codestarconnections_connection" "github" {
  name          = "github"
  provider_type = "GitHub"
}