variable "name" {
  type        = string
  default     = null
  description = "The name of the iam role to create."
}

variable "use_name_as_prefix" {
  type        = bool
  default     = false
  description = "When set to true, [name_prefix] is used at resource level with random suffix"
}

variable "description" {
  type        = string
  default     = null
  description = "The description of the IAM role."
}

variable "path" {
  type        = string
  default     = "/"
  description = "The path of the role within IAM."
}

variable "services" {
  type        = list(string)
  default     = []
  description = "The list of service names allowed to assume role e.g. lambda or ec2."
}

variable "assume_role_policy_document" {
  type        = string
  default     = null
  description = "The IAM policy document allowed to assume the role."
}

variable "policy_documents" {
  type        = list(string)
  default     = []
  description = "The list of IAM policy documents for the role."
}

variable "policy_arns" {
  type        = list(string)
  default     = []
  description = "The list of pre-existing IAM policy ARNs for role."
}

variable "permissions_boundary" {
  type        = string
  default     = null
  description = "ARN of the policy that is used to set the permissions boundary for the role."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to associate with module resources."
}

variable "create_instance_profile" {
  type        = bool
  default     = false
  description = "Creates an IAM instance profile."
}

variable "role_arns" {
  type        = list(string)
  default     = []
  description = "The ARNs of other roles that are allowed to assume the role."
}

variable "max_session_duration" {
  type        = number
  default     = 3600 # 1hr in seconds
  description = "Maximum session duration (in seconds) that you want to set for the specified role."
}
