# set the region
provider "aws" {
  region = "us-east-2"
   access_key = "AKIAWGRXNRVQHNQANY4C"
   secret_key = "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"
}

module "webserver_cluster" {
    #source = "github.com/stedmon8/terraform-repo//Modules/Webserver-Cluster?ref=v0.0.1"
    source = "/Users/stbates/Desktop/New_Terraform_Training/tilt_terraform-main/Modules"

    cluster_name = "tiltz-staging"
    domain_name = "api.tiltz.com"
  



}
# github connection
# using an already existing github connection
# resource "aws_codestarconnections_connection" "github" {
#   name          = "github"
#   provider_type = "GitHub"
# }
