data "aws_elastic_beanstalk_solution_stack" "multi_docker" {
  most_recent = true

  name_regex = "^64bit Amazon Linux (.*) Multi-container Docker (.*)$"
}

resource "aws_s3_bucket" "tilt_s3" {
  bucket = "${var.cluster_name}-beanstalk"
}

# Beanstalk Application
resource "aws_elastic_beanstalk_application" "beanstalk_application" {
  name        = var.cluster_name
  description = var.beanstalk_description
}

# Beanstalk Environment
resource "aws_elastic_beanstalk_environment" "beanstalk_application_environment" {
  name                = "${var.cluster_name}-env"
  application         = aws_elastic_beanstalk_application.beanstalk_application.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.multi_docker.id
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