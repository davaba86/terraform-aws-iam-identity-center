data "aws_ssoadmin_instances" "this" {}

resource "aws_identitystore_user" "this" {
  for_each = var.users

  display_name = "${each.value.name.first_name} ${each.value.name.family_name}"
  user_name    = each.key

  name {
    given_name  = each.value.name.first_name
    family_name = each.value.name.family_name
  }

  emails {
    primary = true
    value   = each.key
    type    = "work"
  }

  phone_numbers {
    primary = true
    value   = each.value.phone
    type    = "work"
  }

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}
