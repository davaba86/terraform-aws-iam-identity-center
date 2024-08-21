variable "users" {
  description = "A map of users to create in the AWS Identity Store"
  type        = map(any)
  default     = {}
}
