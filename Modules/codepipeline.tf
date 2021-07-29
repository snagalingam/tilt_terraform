resource "aws_codepipeline" "codepipeline" {
  name     = var.cluster_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = "codepipeline-${var.cluster_name}"
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
        ProjectName = var.cluster_name
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
        ApplicationName = var.cluster_name
        EnvironmentName = "${var.cluster_name}-env"
      }
    }
  }
}

# s3 bucket
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "codepipeline-${var.cluster_name}"
  acl    = "private"
}
