output "users" {
  description = "Map of Identity Center users keyed by user_name"
  value = {
    for k, u in aws_identitystore_user.this :
    k => {
      user_id      = u.user_id
      user_name    = u.user_name
      display_name = u.display_name
    }
  }
}

output "groups" {
  description = "Map of Identity Center groups keyed by name"
  value = {
    for k, g in aws_identitystore_group.this :
    k => {
      group_id     = g.group_id
      display_name = g.display_name
      description  = g.description
    }
  }
}

output "permission_sets" {
  description = "Map of permission sets keyed by name"
  value = {
    for k, ps in aws_ssoadmin_permission_set.this :
    k => {
      arn         = ps.arn
      name        = ps.name
      description = ps.description
    }
  }
}

output "account_assignments" {
  description = "List of account assignments created by this module"
  value = [
    for k, a in aws_ssoadmin_account_assignment.this : {
      key                = k
      account_id         = a.target_id
      permission_set_arn = a.permission_set_arn
      principal_type     = a.principal_type
      principal_id       = a.principal_id
      target_type        = a.target_type
    }
  ]
}
