output "instance_arn" {
  description = "The ARN of the AWS SSO instance"
  value       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

output "user_names" {
  description = "A list of user names in the AWS Identity Store"
  value = [for user in aws_identitystore_user.this :
    {
      user_name         = user.user_name,
      display_name      = user.display_name,
      user_id           = user.user_id
      identity_store_id = user.identity_store_id
    }
  ]
}
