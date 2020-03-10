variable "account_name" {
  description = "Account name (slug)"
}

variable "org_name" {
  description = "Name for this organization (slug)"
}

variable "create_idp_trusted_roles" {
  description = "Create admin and read-only roles trusting IDP account"
  default     = true
}

variable "idp_account_id" {
  description = "Account ID of IDP account (needs to be set when is_idp_account=true)"
  default     = ""
}

variable "idp_external_trust_account_ids" {
  type        = list(string)
  description = "List of account IDs to trust as external IDPs"
  default     = []
}

variable "role_max_session_duration" {
  description = "Maximum CLI/API session duration"
  default     = "43200"
}

variable "ssm_account_ids" {
  type        = list(string)
  description = "List of account IDs to save in SSM"
  default     = []
}

variable "ssm_account_names" {
  type        = list(string)
  description = "List of account names (slugs) to save in SSM, must match ssm_account_ids"
  default     = []
}

variable "create_ci_profile" {
  description = "Create IAM instance profile and user for use with CI workers deployed to the account"
  default     = false
}

variable "create_ci_role" {
  description = "Create IAM role to assume from MGMT account for CI deployments"
  default     = true
}

variable "ci_account_id" {
  description = "Account ID of MGMT account for use with IAM CI role. Required when create_ci_iam_role=true"
  default     = ""
}

variable "extra_roles" {
  type        = map(string)
  default     = {}
  description = "A map of <role_name> = <json policy> to create extra roles in this account"
}
