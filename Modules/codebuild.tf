# code build
resource "aws_codebuild_project" "codebuild" {
  name          = var.cluster_name
  description   = "tilt backend build"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.codebuild_bucket.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/${var.cluster_name}"
      stream_name = var.cluster_name
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuild_bucket.id}/build-log"
    }
  }

  source {
    type            = "CODEPIPELINE"
    git_clone_depth = 1
  }
}

# s3 bucket
resource "aws_s3_bucket" "codebuild_bucket" {
  bucket = "codebuild-${var.cluster_name}"
  acl    = "private"
}
