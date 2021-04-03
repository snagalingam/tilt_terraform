# chatbot iam role
resource "aws_iam_role" "chatbot_role" {
  name = "tilt-chatbot-role"

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
  name        = "tilt-chatbot-policy"
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
