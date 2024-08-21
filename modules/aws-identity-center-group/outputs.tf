output "instance_arn" {
  description = "The ARN of the AWS SSO instance"
  value       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

output "group_id" {
  description = "The ID of the group in the AWS Identity Store"
  value       = aws_identitystore_group.this.id
}

output "group_display_name" {
  description = "The display name of the group in the AWS Identity Store"
  value       = aws_identitystore_group.this.display_name
}

output "group_description" {
  description = "The description of the group in the AWS Identity Store"
  value       = aws_identitystore_group.this.description
}

output "group_member_user_names" {
  description = "A list of member user names in the group"
  value = [for user in aws_identitystore_group_membership.this :
    {
      # fix: index variable not picked up
      # index     = index(data.aws_identitystore_user.this[*].id, user.member_id)
      # user_name = data.aws_identitystore_user.this[index].user_name
      user_name = data.aws_identitystore_user.this[index(data.aws_identitystore_user.this[*].id, user.member_id)].user_name
    }
  ]
}
