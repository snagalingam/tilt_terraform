# S3 Bucket for storing Elastic Beanstalk task definitions
resource "aws_s3_bucket" "production_s3" {
  bucket = "${var.production_name}-beanstalk"
}

# Beanstalk Application
resource "aws_elastic_beanstalk_application" "production_beanstalk_application" {
  name        = var.production_name
  description = var.production_beanstalk_description
}

# Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "production_beanstalk_application_environment" {
  name                = "${var.production_name}-env"
  application         = aws_elastic_beanstalk_application.production_beanstalk_application.name
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.16.5 running Docker 19.03.13-ce "
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
    value     = aws_iam_instance_profile.beanstalk.name
  }
}
