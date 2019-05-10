data "aws_iam_policy_document" "assume_role_trust_admin" {
  count = "${length(var.idp_admin_trusts)} "

  statement = {
    principals = {
      type = "AWS"

      identifiers = [
        "${var.idp_admin_trusts[count.index]}",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role" "trust_admin" {
  count = "${length(var.idp_admin_trusts)} "

  name                 = "${var.idp_admin_trust_names[count.index]}-admin"
  assume_role_policy   = "${data.aws_iam_policy_document.assume_role_trust_admin.*.json[count.index]}"
  max_session_duration = "${var.role_max_session_duration}"
}

resource "aws_iam_role_policy" "trust_admin" {
  count = "${length(var.idp_admin_trusts)} "

  name = "idp-trust-admin-access-${count.index}"
  role = "${aws_iam_role.trust_admin.*.id[count.index]}"

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
