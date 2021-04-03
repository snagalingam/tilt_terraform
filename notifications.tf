resource "aws_sns_topic" "codepipeline_notifications" {
  name = "codepipeline-notifications"
}

resource "aws_sns_topic_policy" "codepipeline_notifications_policy" {
  arn    = aws_sns_topic.codepipeline_notifications.arn
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codestar-notifications.amazonaws.com"
      },
      "Action": "sns:Publish",
      "Resource": [
        "${aws_sns_topic.codepipeline_notifications.arn}"
      ]
    }
  ]
}
EOF
}

data "local_file" "cloudformation_template" {
  filename = "${path.module}/cloudformation.yml"
}

resource "aws_cloudformation_stack" "chatbot_slack_configuration" {
  name = "cloudformation-notification"
  template_body = data.local_file.cloudformation_template.content
  parameters = {
    ConfigurationNameParameter = var.staging_name
    IamRoleArnParameter        = aws_iam_role.chatbot_role.arn
    LoggingLevelParameter      = "ERROR"
    SlackChannelIdParameter    = "C018V9QMDQ8"
    SlackWorkspaceIdParameter  = "TPZUL0MS9"
    SnsTopicArnsParameter      = join(",", [aws_sns_topic.codepipeline_notifications.arn])
  }
}

# staging
resource "aws_codestarnotifications_notification_rule" "staging_notification_rule" {
  detail_type = "BASIC"
  event_type_ids = [
    "codepipeline-pipeline-pipeline-execution-failed",
    "codepipeline-pipeline-pipeline-execution-canceled",
    "codepipeline-pipeline-pipeline-execution-started",
    "codepipeline-pipeline-pipeline-execution-resumed",
    "codepipeline-pipeline-pipeline-execution-succeeded",
    "codepipeline-pipeline-pipeline-execution-superseded"
  ]
  name     = "slack-notification-rule-staging-codepipeline"
  resource = aws_codepipeline.staging_codepipeline.arn

  target {
    address = aws_sns_topic.codepipeline_notifications.arn
  }
}

# production
resource "aws_codestarnotifications_notification_rule" "production_notification_rule" {
  detail_type = "BASIC"
  event_type_ids = [
    "codepipeline-pipeline-pipeline-execution-failed",
    "codepipeline-pipeline-pipeline-execution-canceled",
    "codepipeline-pipeline-pipeline-execution-started",
    "codepipeline-pipeline-pipeline-execution-resumed",
    "codepipeline-pipeline-pipeline-execution-succeeded",
    "codepipeline-pipeline-pipeline-execution-superseded"
  ]
  name     = "slack-notification-rule-production-codepipeline"
  resource = aws_codepipeline.production_codepipeline.arn

  target {
    address = aws_sns_topic.codepipeline_notifications.arn
  }
}
