data "aws_ssoadmin_instances" "this" {}

data "aws_identitystore_group" "this" {
  for_each = { for group in var.groups : group.name => group }

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = each.value.name
    }
  }

  depends_on = [aws_identitystore_group.this]
}
