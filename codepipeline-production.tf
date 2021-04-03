# code pipeline
resource "aws_codepipeline" "production_codepipeline" {
  name     = var.production_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = "codepipeline-${var.production_name}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Code"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["production_backend_output"]
      configuration = {
        ConnectionArn    = var.aws_github_connection
        FullRepositoryId = var.backend_repository
        BranchName       = var.production_backend_branch
      }
    }
    action {
      name             = "Deployment"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["production_deployment_output"]
      configuration = {
        ConnectionArn    = var.aws_github_connection
        FullRepositoryId = var.production_deployment_repository
        BranchName       = var.production_deployment_branch
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
      input_artifacts = ["production_backend_output"]
      version         = "1"

      configuration = {
        ProjectName = var.production_name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      input_artifacts = ["production_deployment_output"]
      version         = "1"

      configuration = {
        ApplicationName = var.production_name
        EnvironmentName = "${var.production_name}-env"
      }
    }
  }
}

# s3 bucket
resource "aws_s3_bucket" "production_codepipeline_bucket" {
  bucket = "codepipeline-${var.production_name}"
  acl    = "private"
}
