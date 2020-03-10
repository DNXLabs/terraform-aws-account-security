data "aws_iam_policy_document" "assume_role_ci_deploy" {
  statement {
    principals {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${var.ci_account_id}:root",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role" "ci_deploy" {
  count              = var.create_ci_role ? 1 : 0
  name               = "ci-deploy"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ci_deploy.json
}

resource "aws_iam_policy" "ci_deploy" {
  count = var.create_ci_role ? 1 : 0
  name  = "ci-deploy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ci_deploy" {
  count      = var.create_ci_role ? 1 : 0
  role       = aws_iam_role.ci_deploy[0].name
  policy_arn = aws_iam_policy.ci_deploy[0].arn
}
