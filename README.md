# Terraform AWS IAM Identity Center Module

## Usage

1. Pass your AWS account IDs and user details to the `terraform-aws-iam-identity-center` module as shown below. This example includes three AWS accounts (audit, log-archive, and management) and a single user with assigned permission sets.

2. Define one or more users with their details (user name, first name, last name, and phone number).

3. Define permission sets with appropriate policies and session durations.

4. Create groups and assign users to those groups, along with the necessary permission set assignments for each AWS account.

```hcl
module "identity_center" {
  source = "terraform-aws-iam-identity-center"

  aws_accounts = {
    "audit"                = "111111111111",
    "log-archive"          = "222222222222",
    "management"           = "333333333333",
  }

  users = [
    {
      user_name    = "user.name@company.com"
      first_name   = "User"
      last_name    = "Name"
      phone_number = "+1234567890"
    }
  ]

  permission_sets = [
    {
      name             = "admin-break-glass"
      description      = "Break glass permission set with AdministratorAccess for emergency use only"
      policies         = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      session_duration = "PT4H"
    },
    {
      name             = "security-auditor"
      description      = "Permissions for security auditing and monitoring"
      policies         = ["arn:aws:iam::aws:policy/SecurityAudit"]
      session_duration = "PT4H"
    },
    {
      name             = "read-only"
      description      = "Read-only access to AWS resources"
      policies         = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
      session_duration = "PT4H"
    },
  ]

  groups = [
    {
      name        = "platform"
      description = "Platform group for managing access"
      members     = ["user.name@company.com"]
      permission_assignments = [
        {
          account_id = "audit"
          ps_name    = ["admin-break-glass"]
        },
        {
          account_id = "log-archive"
          ps_name    = ["admin-break-glass"]
        },
        {
          account_id = "management"
          ps_name    = ["admin-break-glass"]
        }
      ]
    },
    {
      name        = "security-auditors"
      description = "Group for security auditors with SecurityAudit permissions"
      permission_assignments = [
        {
          account_id = "audit"
          ps_name    = ["security-auditor"]
        },
        {
          account_id = "log-archive"
          ps_name    = ["security-auditor"]
        },
        {
          account_id = "management"
          ps_name    = ["security-auditor"]
        }
      ]
    },
    {
      name        = "read-only-users"
      description = "Group for users with read-only access"
    }
  ]
}
```

As you see user membership and permission set assignments are defined at the group level, allowing for easy management of user access across multiple AWS accounts. You can customize the users, permission sets, and groups as needed for your specific use case.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.36 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.37.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_identitystore_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group) | resource |
| [aws_identitystore_group_membership.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_group_membership) | resource |
| [aws_identitystore_user.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/identitystore_user) | resource |
| [aws_ssoadmin_account_assignment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_account_assignment) | resource |
| [aws_ssoadmin_permission_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssoadmin_permission_set) | resource |
| [aws_ssoadmin_instances.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssoadmin_instances) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_accounts"></a> [aws\_accounts](#input\_aws\_accounts) | A list of AWS accounts to assign permission sets to. | `map(string)` | `{}` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region to create resources in. | `string` | `"eu-west-1"` | no |
| <a name="input_groups"></a> [groups](#input\_groups) | A list of groups to create in Identity Center. | <pre>list(object({<br/>    name        = string<br/>    description = string<br/>    members     = optional(list(string))<br/>    permission_assignments = optional(list(object({<br/>      account_id = string<br/>      ps_name    = list(string)<br/>    })), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_permission_sets"></a> [permission\_sets](#input\_permission\_sets) | A list of permission sets to create in Identity Center. | <pre>list(object({<br/>    name             = string<br/>    description      = string<br/>    policies         = list(string)<br/>    session_duration = optional(string, "PT8H")<br/>  }))</pre> | `[]` | no |
| <a name="input_users"></a> [users](#input\_users) | A list of users to create in Identity Center. | <pre>list(object({<br/>    user_name    = string<br/>    first_name   = string<br/>    last_name    = string<br/>    phone_number = optional(string)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_assignments"></a> [account\_assignments](#output\_account\_assignments) | List of account assignments created by this module |
| <a name="output_groups"></a> [groups](#output\_groups) | Map of Identity Center groups keyed by name |
| <a name="output_permission_sets"></a> [permission\_sets](#output\_permission\_sets) | Map of permission sets keyed by name |
| <a name="output_users"></a> [users](#output\_users) | Map of Identity Center users keyed by user\_name |
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.
