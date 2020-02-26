data "aws_iam_policy_document" "assume_role_extra" {
  count = length(keys(var.extra_roles))

  statement {
    principals {
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

resource "aws_iam_role" "extra" {
  count = length(keys(var.extra_roles))

  name                 = "${var.org_name}-${var.account_name}-${element(keys(var.extra_roles), count.index)}"
  assume_role_policy   = data.aws_iam_policy_document.assume_role_extra[count.index].json
  max_session_duration = var.role_max_session_duration
}

resource "aws_iam_role_policy" "extra" {
  count = length(keys(var.extra_roles))

  name   = "idp-${element(keys(var.extra_roles), count.index)}-access"
  role   = aws_iam_role.extra[count.index].id
  policy = element(values(var.extra_roles), count.index)
}
