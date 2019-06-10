data "aws_iam_policy_document" "assume_role_admin" {
  count = "${var.idp_account_id != "" ? 1 : 0}"

  statement = {
    principals = {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${var.idp_account_id}:role/${var.org_name}-admin",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role" "admin" {
  count = "${var.idp_account_id != "" ? 1 : 0}"

  name                 = "${var.org_name}-${var.account_name}-admin"
  assume_role_policy   = "${data.aws_iam_policy_document.assume_role_admin.json}"
  max_session_duration = "${var.role_max_session_duration}"
}

resource "aws_iam_role_policy" "admin" {
  count = "${var.idp_account_id != "" ? 1 : 0}"

  name = "idp-admin-access"
  role = "${aws_iam_role.admin.id}"

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
