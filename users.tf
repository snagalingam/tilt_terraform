resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/users/"

}

resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::test"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::test/*"]
    }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_user" "Terraform_S3_user_policy" {
  name = "S3User"
  path = "/system/"

}

resource "aws_iam_group_membership" "developers" {
  name = "developers"

  users = [
    aws_iam_user.Terraform_S3_user_policy.name
  ]

  group = aws_iam_group.developers.name
}