output "instance_arn" {
  description = "The ARN of the AWS SSO instance"
  value       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

output "permission_set_name" {
  description = "The name of the permission set"
  value       = aws_ssoadmin_permission_set.this.name
}

output "permission_set_arn" {
  description = "The ARN of the permission set"
  value       = aws_ssoadmin_permission_set.this.arn
}

output "group_id" {
  description = "The ID of the group in the AWS Identity Store"
  value       = data.aws_identitystore_group.this.group_id
}

output "group_name" {
  description = "The name of the group in the AWS Identity Store"
  value       = var.identity_center_group_name
}

output "permission_set_session_duration" {
  description = "The session duration of the permission set"
  value       = aws_ssoadmin_permission_set.this.session_duration
}

output "attached_policy_arns" {
  description = "A list of ARNs of policies attached to the permission set"
  value       = aws_ssoadmin_managed_policy_attachment.this[*].managed_policy_arn
}

output "attached_aws_account_ids" {
  description = "A list of AWS account IDs attached to the permission set"
  value       = aws_ssoadmin_account_assignment.this[*].target_id
}
