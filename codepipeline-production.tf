# code pipeline
resource "aws_codepipeline" "codepipeline" {
  name     = var.pipeline_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = "codepipeline-${var.pipeline_name}"
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
      output_artifacts = ["backend_output"]
      configuration = {
        ConnectionArn    = "arn:aws:codestar-connections:us-east-2:614818178581:connection/55bda5c3-35a6-4bd4-9886-b342a185a1dc"
        FullRepositoryId = var.backend_repository
        BranchName       = var.backend_branch
      }
    }
    action {
      name             = "Deployment"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["deployment_output"]
      configuration = {
        ConnectionArn    = "arn:aws:codestar-connections:us-east-2:614818178581:connection/55bda5c3-35a6-4bd4-9886-b342a185a1dc"
        FullRepositoryId = var.deployment_repository
        BranchName       = var.deployment_branch
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
      input_artifacts = ["backend_output"]
      version         = "1"

      configuration = {
        ProjectName = var.pipeline_name
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
      input_artifacts = ["deployment_output"]
      version         = "1"

      configuration = {
        ApplicationName = var.pipeline_name
        EnvironmentName = "${var.pipeline_name}-env"
      }
    }
  }
}

# s3 bucket
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "codepipeline-${var.pipeline_name}"
  acl    = "private"
}

# codepipeline instance profile
resource "aws_iam_instance_profile" "beanstalk" {
  name  = "codepipeline-${var.pipeline_name}"
  role  = aws_iam_role.codepipeline_role.name
}

# codepipeline iam role
resource "aws_iam_role" "codepipeline_role" {
  name =  "codepipeline-${var.pipeline_name}-role"

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

# codepipeline iam policy
resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline-policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "acm:DescribeCertificate",
        "acm:ListCertificates",
        "appconfig:StartDeployment",
        "appconfig:GetDeployment",
        "appconfig:StopDeployment",
        "autoscaling:*",
        "cloudformation:*",
        "cloudwatch:*",
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "codestar-connections:CreateConnection",
        "codestar-connections:DeleteConnection",
        "codestar-connections:UseConnection",
        "codestar-connections:GetConnection",
        "codestar-connections:ListConnections",
        "codestar-connections:ListInstallationTargets",
        "codestar-connections:GetInstallationUrl",
        "codestar-connections:StartOAuthHandshake",
        "codestar-connections:UpdateConnectionInstallation",
        "codestar-connections:GetIndividualAccessToken",
        "codestar-connections:TagResource",
        "codestar-connections:ListTagsForResource",
        "codestar-connections:UntagResource",
        "dynamodb:*",
        "ec2:*",
        "ecr:*",
        "ecs:*",
        "elasticbeanstalk:*",
        "elasticloadbalancing:*",
        "iam:GetPolicyVersion",
        "iam:GetRole",
        "iam:PassRole",
        "iam:ListRolePolicies",
        "iam:ListAttachedRolePolicies",
        "iam:ListInstanceProfiles",
        "iam:ListRoles",
        "iam:ListServerCertificates",
        "logs:*",
        "rds:*",
        "s3:*",
        "sns:*",
        "sqs:*"
      ],
      "Resource": "*"
    },
    {
      "Action": [
        "iam:AddRoleToInstanceProfile",
        "iam:CreateInstanceProfile",
        "iam:CreateRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::*:role/aws-elasticbeanstalk*",
        "arn:aws:iam::*:instance-profile/aws-elasticbeanstalk*"
      ]
    },
    {
      "Action": [
        "iam:CreateServiceLinkedRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::*:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling*"
      ],
      "Condition": {
        "StringLike": {
          "iam:AWSServiceName": "autoscaling.amazonaws.com"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateServiceLinkedRole"
      ],
      "Resource": [
        "arn:aws:iam::*:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing*"
      ],
      "Condition": {
        "StringLike": {
          "iam:AWSServiceName": "elasticloadbalancing.amazonaws.com"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:AttachRolePolicy"
      ],
      "Resource": "arn:aws:iam::*:role/aws-elasticbeanstalk*",
      "Condition": {
        "StringLike": {
          "iam:PolicyArn": [
            "arn:aws:iam::aws:policy/AWSElasticBeanstalk*",
            "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalk*"
          ]
        }
      }
    },
    {
      "Action": "codestar-connections:*",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:codestar-connections:*:614818178581:host/*",
        "arn:aws:codestar-connections:*:614818178581:connection/*"
      ]
    },
    {
      "Action": "s3:*",
      "Effect":"Allow",
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    }
  ]
}
EOF
}
