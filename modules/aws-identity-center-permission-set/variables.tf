variable "name" {
  description = "The name of the permission set"
  type        = string
  default     = ""
}

variable "description" {
  description = "The description of the permission set"
  type        = string
  default     = ""
}

variable "session_duration_hours" {
  description = "The session duration in hours"
  type        = number
  default     = 1
}

variable "attached_policy_arns" {
  description = "A list of ARNs of policies to attach to the permission set"
  type        = list(string)
  default     = []
}

variable "attached_aws_account_ids" {
  description = "A list of AWS account IDs to attach to the permission set"
  type        = list(string)
  default     = []
}

variable "identity_center_group_name" {
  description = "The name of the group in the AWS Identity Store"
  type        = string
  default     = ""
}

variable "instance_arn" {
  description = "The ARN of the SSO instance in case multiple AWS accounts and delegation is used."
  type        = string
}

variable "instance_store_id" {
  description = "The ID of the identity store in case multiple AWS accounts and delegation is used."
  type        = string
}
