resource "aws_ssm_parameter" "account_id" {
  count = length(var.ssm_account_ids)
  name  = "/account/${var.ssm_account_names[count.index]}/id"
  type  = string
  value = var.ssm_account_ids[count.index]
}
