data "aws_iam_policy_document" "assume_role_mgmt_ci_deploy_ec2" {
  statement {
    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role" "mgmt_ci_deploy_ec2" {
  count              = var.create_ci_profile ? 1 : 0
  name               = "ci-deploy-ec2"
  assume_role_policy = data.aws_iam_policy_document.assume_role_mgmt_ci_deploy_ec2.json
}

resource "aws_iam_instance_profile" "mgmt_ci_deploy_ec2" {
  count = var.create_ci_profile ? 1 : 0
  name  = "ci-deploy"
  role  = aws_iam_role.mgmt_ci_deploy_ec2[0].name
}

resource "aws_iam_user" "mgmt_ci_deploy" {
  count = var.create_ci_profile ? 1 : 0
  name  = "ci-deploy"
}

resource "aws_iam_policy" "mgmt_ci_deploy" {
  count = var.create_ci_profile ? 1 : 0
  name  = "ci-deploy-mgmt"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": [
              "arn:aws:iam::*:role/ci-deploy",
              "arn:aws:iam::*:role/terraform-backend*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "ecr:*",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "mgmt_ci_deploy_ec2" {
  count      = var.create_ci_profile ? 1 : 0
  role       = aws_iam_role.mgmt_ci_deploy_ec2[0].name
  policy_arn = aws_iam_policy.mgmt_ci_deploy[0].arn
}

resource "aws_iam_user_policy_attachment" "mgmt_ci_deploy" {
  count      = var.create_ci_profile ? 1 : 0
  user       = aws_iam_user.mgmt_ci_deploy[0].name
  policy_arn = aws_iam_policy.mgmt_ci_deploy[0].arn
}
