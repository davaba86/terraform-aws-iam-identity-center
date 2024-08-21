variable "display_name" {
  description = "The display name of the group"
  type        = string
  default     = ""
}

variable "description" {
  description = "The description of the group"
  type        = string
  default     = ""
}

variable "group_user_emails" {
  description = "A list of user emails to add to the group"
  type        = list(string)
  default     = []
}
