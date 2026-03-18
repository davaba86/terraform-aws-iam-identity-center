# Terraform AWS IAM Identity Center Module

## Usage

1. Pass your AWS account IDs and user details to the `terraform-aws-iam-identity-center` module as shown below. This example includes three AWS accounts (audit, log-archive, and management) and a single user with assigned permission sets.

2. Define one or more users with their details (user name, first name, last name, and phone number).

3. Define permission sets with appropriate policies and session durations.

4. Create groups and assign users to those groups, along with the necessary permission set assignments for each AWS account.

````json
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

## License

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.
