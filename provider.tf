# set the region
provider "aws" {
  region = "us-east-2"
  access_key = "<<REDACTED>>"
  secret_key = "<<REDACTED>>"
}

# github connection
resource "aws_codestarconnections_connection" "github" {
  name          = "github"
  provider_type = "GitHub"
}