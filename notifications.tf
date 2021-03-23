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

resource "aws_codestarnotifications_notification_rule" "notification_rule" {
  detail_type = "BASIC"
  event_type_ids = [
    "codepipeline-pipeline-pipeline-execution-failed",
    "codepipeline-pipeline-pipeline-execution-canceled",
    "codepipeline-pipeline-pipeline-execution-started",
    "codepipeline-pipeline-pipeline-execution-resumed",
    "codepipeline-pipeline-pipeline-execution-succeeded",
    "codepipeline-pipeline-pipeline-execution-superseded"
  ]
  name     = "alerts-ci-slack-notification-rule-codepipeline"
  resource = aws_codepipeline.codepipeline.arn

  target {
    address = aws_sns_topic.codepipeline_notifications.arn
  }
}

# chatbot iam role
resource "aws_iam_role" "chatbot_role" {
  name = "chatbot-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "chatbot.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# chatbot iam policy
resource "aws_iam_role_policy" "chatbot_policy" {
  name        = "chatbot-policy"
  role        = aws_iam_role.chatbot_role.id

  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

data "local_file" "cloudformation_template" {
  filename = "${path.module}/cloudformation.yml"
}

resource "aws_cloudformation_stack" "chatbot_slack_configuration" {
  name = "cloudformation-notification-${var.pipeline_name}"
  template_body = data.local_file.cloudformation_template.content
  parameters = {
    ConfigurationNameParameter = var.pipeline_name
    IamRoleArnParameter        = aws_iam_role.chatbot_role.arn
    LoggingLevelParameter      = "ERROR"
    SlackChannelIdParameter    = "C018V9QMDQ8"
    SlackWorkspaceIdParameter  = "TPZUL0MS9"
    SnsTopicArnsParameter      = join(",", [aws_sns_topic.codepipeline_notifications.arn])
  }
}
