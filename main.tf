resource "aws_identitystore_user" "this" {
  for_each = { for user in var.users : user.user_name => user }

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  user_name    = each.value.user_name
  display_name = "${each.value.first_name} ${each.value.last_name}"

  name {
    given_name  = each.value.first_name
    family_name = each.value.last_name
  }

  emails {
    value   = each.value.user_name
    primary = true
    type    = "work"
  }

  phone_numbers {
    value   = each.value.phone_number
    primary = true
    type    = "work"
  }
}

resource "aws_identitystore_group" "this" {
  for_each = { for group in var.groups : group.name => group }

  display_name      = each.value.name
  description       = each.value.description
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

resource "aws_identitystore_group_membership" "this" {
  for_each = {
    for assignment in flatten([
      for group in var.groups : [
        for member in(group.members != null ? group.members : []) : {
          key        = "${group.name}-${member}"
          group_name = group.name
          member     = member
        }
      ]
    ]) : assignment.key => assignment
  }

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  group_id  = aws_identitystore_group.this[each.value.group_name].group_id
  member_id = aws_identitystore_user.this[each.value.member].user_id
}

resource "aws_ssoadmin_permission_set" "this" {
  for_each = { for ps in var.permission_sets : ps.name => ps }

  name             = each.value.name
  description      = each.value.description
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  session_duration = each.value.session_duration
}

resource "aws_ssoadmin_account_assignment" "this" {
  for_each = {
    for assignment in flatten([
      for group in var.groups : [
        for pa in group.permission_assignments : [
          for ps_name in pa.ps_name : {
            key        = "${group.name}-${pa.account_id}-${ps_name}"
            group_name = group.name
            account_id = pa.account_id
            ps_name    = ps_name
          }
        ]
      ]
    ]) : assignment.key => assignment
  }

  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.ps_name].arn

  principal_id   = aws_identitystore_group.this[each.value.group_name].group_id
  principal_type = "GROUP"

  target_id   = var.aws_accounts[each.value.account_id]
  target_type = "AWS_ACCOUNT"
}
