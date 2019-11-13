data "aws_iam_policy_document" "assume_role_trust_admin" {
  count = "${length(var.idp_admin_trust_account_ids)}"

  statement = {
    principals = {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${var.idp_admin_trust_account_ids[count.index]}:role/client-${var.org_name}-admin",
        "arn:aws:iam::${var.idp_admin_trust_account_ids[count.index]}:role/client-admin"
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role" "trust_admin" {
  count = "${length(var.idp_admin_trust_account_ids)}"

  name                 = "${var.idp_admin_trust_names[count.index]}-admin"
  assume_role_policy   = "${data.aws_iam_policy_document.assume_role_trust_admin.*.json[count.index]}"
  max_session_duration = "${var.role_max_session_duration}"
}

resource "aws_iam_role_policy" "trust_admin" {
  count = "${length(var.idp_admin_trust_account_ids)}"

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
