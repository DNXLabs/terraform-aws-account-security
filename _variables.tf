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

variable "idp_trusts" {
  type        = "list"
  description = "List of role ARNs to trust as external IDPs"
  default     = []
}

variable "role_max_session_duration" {
  description = "Maximum CLI/API session duration"
  default     = "43200"
}
