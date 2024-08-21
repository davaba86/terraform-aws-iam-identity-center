data "aws_ssoadmin_instances" "this" {}

resource "aws_identitystore_group" "this" {
  display_name = var.display_name
  description  = var.description

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

data "aws_identitystore_user" "this" {
  count = length(var.group_user_emails)

  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = var.group_user_emails[count.index]
    }
  }

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

resource "aws_identitystore_group_membership" "this" {
  count = length(data.aws_identitystore_user.this)

  group_id  = aws_identitystore_group.this.group_id
  member_id = data.aws_identitystore_user.this[count.index].id

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}
