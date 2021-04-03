# codepipeline instance profile
resource "aws_iam_instance_profile" "codepipeline" {
  name  = "codepipeline-tilt"
  role  = aws_iam_role.codepipeline_role.name
}

# codepipeline iam role
resource "aws_iam_role" "codepipeline_role" {
  name =  "codepipeline-tilt-role"

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
  name = "codepipeline-tilt-policy"
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
        "codestar-connections:*",
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
    }
  ]
}
EOF
}
