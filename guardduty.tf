resource "aws_guardduty_detector" "member" {
  count = "${var.master_guardduty_id != "" ? 1 : 0}"
}

resource "aws_guardduty_member" "account" {
  count    = "${var.master_guardduty_id != "" ? 1 : 0}"
  provider = "aws.master"

  account_id                 = "${aws_guardduty_detector.member.*.account_id[0]}"
  detector_id                = "${var.master_guardduty_id}"
  email                      = "${var.account_email}"
  invite                     = true
  disable_email_notification = true
}

data "aws_caller_identity" "master" {
  provider = "aws.master"
}

resource "aws_guardduty_invite_accepter" "member" {
  count      = "${var.master_guardduty_id != "" ? 1 : 0}"
  depends_on = ["aws_guardduty_member.account"]

  detector_id       = "${aws_guardduty_detector.member.*.id[0]}"
  master_account_id = "${data.aws_caller_identity.master.account_id}"
}
