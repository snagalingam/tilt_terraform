resource "aws_codepipeline" "staging_codepipeline" {
  name     = var.staging_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = "codepipeline-${var.staging_name}"
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
      output_artifacts = ["staging_backend_output"]
      configuration = {
        ConnectionArn    = var.aws_github_connection
        FullRepositoryId = var.backend_repository
        BranchName       = var.staging_backend_branch
      }
    }
    action {
      name             = "Deployment"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["staging_deployment_output"]
      configuration = {
        ConnectionArn    = var.aws_github_connection
        FullRepositoryId = var.staging_deployment_repository
        BranchName       = var.staging_deployment_branch
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
      input_artifacts = ["staging_backend_output"]
      version         = "1"

      configuration = {
        ProjectName = var.staging_name
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
      input_artifacts = ["staging_deployment_output"]
      version         = "1"

      configuration = {
        ApplicationName = var.staging_name
        EnvironmentName = "${var.staging_name}-env"
      }
    }
  }
}

# s3 bucket
resource "aws_s3_bucket" "staging_codepipeline_bucket" {
  bucket = "codepipeline-${var.staging_name}"
  acl    = "private"
}
