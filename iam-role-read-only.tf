resource "aws_iam_role" "read_only" {
  count = "${var.idp_account_id != "" ? 1 : 0}"

  name                 = "${var.org_name}-${var.account_name}-read-only"
  assume_role_policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS":
          ${jsonencode(concat(
            list(
              "arn:aws:iam::${var.idp_account_id}:root"
            ), 
            formatlist(
              "arn:aws:iam::%s:role/${var.org_name}-read-only", var.idp_admin_trust_account_ids
            ),
            formatlist(
              "arn:aws:iam::%s:role/client-read-only", var.idp_admin_trust_account_ids
            )
          ))}
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  max_session_duration = "${var.role_max_session_duration}"
}

resource "aws_iam_policy_attachment" "read_only" {
  count = "${var.idp_account_id != "" ? 1 : 0}"

  name       = "idp-read-only-attachment"
  roles      = ["${aws_iam_role.read_only.*.name[0]}"]
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
