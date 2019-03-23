data "aws_iam_policy_document" "assume_role_read_only" {
  count = "${var.idp_account_id != "" ? 1 : 0}"

  statement = {
    principals = {
      type = "AWS"

      identifiers = [
        "arn:aws:iam::${var.idp_account_id}:root",
      ]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

resource "aws_iam_role" "read_only" {
  count = "${var.idp_account_id != "" ? 1 : 0}"

  name                 = "${var.org_name}-${var.account_name}-read-only"
  assume_role_policy   = "${data.aws_iam_policy_document.assume_role_read_only.json}"
  max_session_duration = "${var.role_max_session_duration}"
}

resource "aws_iam_policy_attachment" "read_only" {
  count = "${var.idp_account_id != "" ? 1 : 0}"

  name       = "idp-read-only-attachment"
  roles      = ["${aws_iam_role.read_only.name}"]
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
