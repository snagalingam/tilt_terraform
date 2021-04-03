# set the region
provider "aws" {
  region = "us-east-2"
  access_key = "AKIAY6JQE4YKVO6SVJ3Y"
  secret_key = "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"
}

# github connection
resource "aws_codestarconnections_connection" "github" {
  name          = "github"
  provider_type = "GitHub"
}