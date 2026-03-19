variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "eu-west-1"
}

variable "aws_accounts" {
  description = "A list of AWS accounts to assign permission sets to."
  type        = map(string)
  default     = {}
}

variable "users" {
  description = "A list of users to create in Identity Center."
  type = list(object({
    user_name    = string
    first_name   = string
    last_name    = string
    phone_number = optional(string)
  }))
  default = []
}

variable "groups" {
  description = "A list of groups to create in Identity Center."
  type = list(object({
    name        = string
    description = string
    members     = optional(list(string))
    permission_assignments = optional(list(object({
      account_id = string
      ps_name    = list(string)
    })), [])
  }))
  default = []
}

variable "permission_sets" {
  description = "A list of permission sets to create in Identity Center."
  type = list(object({
    name             = string
    description      = string
    policies         = list(string)
    session_duration = optional(string, "PT8H")
  }))
  default = []
}
