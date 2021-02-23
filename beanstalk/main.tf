# set the region
provider "aws" {
  region = "us-east-2"
}

# S3 Bucket for storing Elastic Beanstalk task definitions
resource "aws_s3_bucket" "s3" {
  bucket = "${var.main_name}-deployments"
}

# Elastic Container Repository for Docker images
resource "aws_ecr_repository" "ecr" {
  name                 = "${var.main_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.domain_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Beanstalk instance profile
resource "aws_iam_instance_profile" "beanstalk" {
  name  = "beanstalk-${var.main_name}"
  role  = "${aws_iam_role.beanstalk.name}"
}

resource "aws_iam_role" "beanstalk" {
  name = "beanstalk-${var.main_name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
EOF
}

# Beanstalk EC2 Policy
# Overriding because by default Beanstalk does not have a permission to Read ECR
resource "aws_iam_role_policy" "beanstalk_policy" {
  name = "beanstalk-policy-with-ECR"
  role = aws_iam_role.beanstalk.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:PutMetricData",
        "ds:CreateComputer",
        "ds:DescribeDirectories",
        "ec2:DescribeInstanceStatus",
        "logs:*",
        "ssm:*",
        "ec2messages:*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage",
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Beanstalk Application
resource "aws_elastic_beanstalk_application" "beanstalk_application" {
  name        = "${var.main_name}"
  description = "${var.beanstalk_description}"
}

# Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "beanstalk_application_environment" {
  name                = "${var.main_name}-env"
  application         = "${aws_elastic_beanstalk_application.beanstalk_application.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.16.4 running Docker 19.03.13-ce "
  tier                = "WebServer"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "2"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${aws_iam_instance_profile.beanstalk.name}"
  }
}
