variable "account_name" {
  description = "Account name (slug)"
}

variable "org_name" {
  description = "Name for this organization (slug)"
}

variable "idp_account_id" {
  description = "Account ID of IDP account"
  default     = ""
}

variable "idp_admin_trust_account_ids" {
  type        = "list"
  description = "List of account IDs to trust as external IDPs"
  default     = []
}

variable "idp_admin_trust_names" {
  type        = "list"
  description = "Names for external IDPs for roles (must match idp_admin_trust_account_ids)"
  default     = []
}

variable "role_max_session_duration" {
  description = "Maximum CLI/API session duration"
  default     = "43200"
}

variable "ssm_account_ids" {
  type        = "list"
  description = "List of account IDs to save in SSM"
  default     = []
}

variable "ssm_account_names" {
  type        = "list"
  description = "List of account names (slugs) to save in SSM, must match ssm_account_ids"
  default     = []
}

variable "iam_ci_mgmt" {
  description = "Create IAM instance profile and user for use with CI workers deployed to the account"
  default     = false
}

variable "iam_ci_mgmt_account_id" {
  description = "Account ID of MGMT account for use with IAM CI role. It creates IAM role to assume from MGMT account for CI deployments"
  default     = ""
}

variable "extra_roles" {
  type        = "map"
  default     = {}
  description = "A map of <role_name> = <json policy> to create extra roles in this account"
}
