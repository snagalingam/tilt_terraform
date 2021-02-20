# set the region
provider "aws" {
  region = "us-east-2"
}

# S3 Bucket for storing Elastic Beanstalk task definitions
resource "aws_s3_bucket" "s3" {
  bucket = aws_codepipeline.tilt_staging_build.name
}

resource "aws_codepipeline" "tilt_staging_build" {
  name     = "tilt-staging-build-pipeline"
  role_arn = aws_iam_role.tilt_staging_build.arn

  artifact_store {
    location = aws_s3_bucket.s3.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["tilt-staging-code"]

      configuration = {
        Owner  = "snagalingam"
        Repo   = "tilt_backend"
        Branch = "feature/update-deployment"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["tilt-staging-code"]
      version         = "1"

      configuration = {
        ProjectName = "tilt-staging-build"
      }
    }
  }
}

# A shared secret between GitHub and AWS that allows AWS
# CodePipeline to authenticate the request came from GitHub.
# Would probably be better to pull this from the environment
# or something like SSM Parameter Store.
locals {
  webhook_secret = "super-secret"
}

resource "aws_codepipeline_webhook" "tilt_staging_build" {
  name            = "tilt-webhook-github"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.tilt_staging_build.name

  authentication_configuration {
    secret_token = local.webhook_secret
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}

# Wire the CodePipeline webhook into a GitHub repository.
resource "github_repository_webhook" "tilt_staging_build" {
  repository = github_repository.repo.name

  name = "web"

  configuration {
    url          = aws_codepipeline_webhook.tilt_staging_build.url
    content_type = "json"
    insecure_ssl = true
    secret       = local.webhook_secret
  }

  events = ["push"]
}