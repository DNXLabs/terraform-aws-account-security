# terraform-aws-account-security

[![Lint Status](https://github.com/DNXLabs/terraform-aws-account-security/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-account-security/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-account-security)](https://github.com/DNXLabs/terraform-aws-account-security/blob/master/LICENSE)

This terraform module creates IAM roles for federated users to assume from an IdP account.

It creates 2 roles:
* `idp-admin` with full admin permissions
* `idp-read-only` with read-only permissions

## Usage

```hcl
module "my_account_roles" {
  source                = "git::https://github.com/DNXLabs/terraform-aws-account-roles.git?ref=0.2.0"
  org_name              = "my_organization"
  account_name          = "my_account"
  idp_account_id        = "000000000000"

  idp_admin_trust_account_ids = ["1234567890123"] # optional
  idp_admin_trust_names       = ["dnx"]                        # optional
}
```

Deploy this module to every AWS account, except _IdP_ and _master_.

You will need an AWS Organization created in the _master_ account and an IdP account with federated login.

Use `idp_admin_trust_account_ids` and `idp_admin_trust_names` to allow access from external accounts. Enter a list of IDs of IDP accounts that will be able to assume to this account.

See:
* Create an organization with [terraform-aws-organization](https://github.com/DNXLabs/terraform-aws-organization) 
* Create accounts with [terraform-aws-account](https://github.com/DNXLabs/terraform-aws-account)
* Deploy IdP IAM roles (for gsuite) with [terraform-aws-idp-gsuite](https://github.com/DNXLabs/terraform-aws-idp-gsuite)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| account\_name | Account name (slug) | string | n/a | yes |
| idp\_account\_id | Account ID of IDP account | string | `""` | no |
| idp\_trusts | List of role ARNs to trust as external IDPs | list | `<list>` | no |
| org\_name | Name for this organization (slug) | string | n/a | yes |
| role\_max\_session\_duration | Maximum CLI/API session duration | string | `"43200"` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam\_role\_admin\_arn | ARN for admin IAM role |
| iam\_role\_read\_only\_arn | ARN for read-only IAM role |

## Authors

Module managed by [Allan Denot](https://github.com/adenot).

## License

Apache 2 Licensed. See LICENSE for full details.