# code build
resource "aws_codebuild_project" "staging_codebuild" {
  name          = var.staging_pipeline_name
  description   = "tilt backend build"
  build_timeout = "5"
  service_role  = aws_iam_role.staging_codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.staging_codebuild_bucket.bucket
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
      group_name  = "/aws/codebuild/${var.staging_pipeline_name}"
      stream_name = var.staging_pipeline_name
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.staging_codebuild_bucket.id}/build-log"
    }
  }

  source {
    type            = "CODEPIPELINE"
    git_clone_depth = 1
  }
}

# s3 bucket
resource "aws_s3_bucket" "staging_codebuild_bucket" {
  bucket = "codebuild-${var.staging_pipeline_name}"
  acl    = "private"
}

# codebuild iam instance profile
resource "aws_iam_instance_profile" "staging_codebuild" {
  name  = "codebuild-${var.staging_pipeline_name}"
  role  = aws_iam_role.staging_codebuild_role.name
}

# codebuild iam role
resource "aws_iam_role" "staging_codebuild_role" {
  name = "codebuild-${var.staging_pipeline_name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# codebuild iam policy
resource "aws_iam_role_policy" "staging_codebuild_policy" {
  name = "codebuild-${var.staging_pipeline_name}-policy"
  role = aws_iam_role.staging_codebuild_role.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": [
        "*"
      ]
    },
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.staging_codebuild_bucket.arn}",
        "${aws_s3_bucket.staging_codebuild_bucket.arn}/*",
        "${aws_s3_bucket.staging_codepipeline_bucket.arn}",
        "${aws_s3_bucket.staging_codepipeline_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "ecr:*",
        "cloudtrail:LookupEvents"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "iam:CreateServiceLinkedRole"
      ],
      "Condition": {
        "StringEquals": {
          "iam:AWSServiceName": [
            "replication.ecr.amazonaws.com"
          ]
        }
      },
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
