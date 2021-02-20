# set the region
provider "aws" {
  region = "us-east-2"
}

# code pipeline
resource "aws_codepipeline" "tilt_staging_build" {
  name     = "tilt-staging-build-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = "codepipeline-${var.application_name}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["tilt-staging-code"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "snagalingam/tilt_backend"
        BranchName       = "feature/update-deployment"
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

# github connection
resource "aws_codestarconnections_connection" "github" {
  name          = "aws-github"
  provider_type = "GitHub"
}

# s3 bucket
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "codepipeline-${var.application_name}"
  acl    = "private"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "test-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:CreateConnection",
        "codestar-connections:DeleteConnection",
        "codestar-connections:UseConnection",
        "codestar-connections:GetConnection",
        "codestar-connections:ListConnections"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
