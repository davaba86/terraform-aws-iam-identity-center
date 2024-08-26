data "aws_ssoadmin_instances" "this" {}

locals {
  instance_arn = var.instance_arn != null ? var.instance_arn : tolist(data.aws_ssoadmin_instances.this.arns)[0]

  instance_store_id = var.instance_store_id != null ? var.instance_store_id : tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

resource "aws_ssoadmin_permission_set" "this" {
  name             = var.name
  description      = var.description
  session_duration = "PT${var.session_duration_hours}H"

  instance_arn = local.instance_arn
}


resource "aws_ssoadmin_managed_policy_attachment" "this" {
  count = length(var.attached_policy_arns)

  managed_policy_arn = var.attached_policy_arns[count.index]
  permission_set_arn = aws_ssoadmin_permission_set.this.arn

  instance_arn = local.instance_arn
}

data "aws_identitystore_group" "this" {
  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = var.identity_center_group_name
    }
  }

  identity_store_id = local.instance_store_id
}

resource "aws_ssoadmin_account_assignment" "this" {
  count = length(var.attached_aws_account_ids)

  permission_set_arn = aws_ssoadmin_permission_set.this.arn

  principal_id   = data.aws_identitystore_group.this.group_id
  principal_type = "GROUP"

  target_id   = var.attached_aws_account_ids[count.index]
  target_type = "AWS_ACCOUNT"

  instance_arn = local.instance_arn
}
