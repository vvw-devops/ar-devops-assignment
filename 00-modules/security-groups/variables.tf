variable "name" {
  type        = string
  description = "Security Group Name"
}

variable "use_name_as_prefix" {
  type        = bool
  default     = false
  description = "When set to true, [name_prefix] is used at resource level with random suffix"
}

variable "description" {
  type        = string
  default     = "Managed by Terraform"
  description = "Security Group Description"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID in which to create this Security Group"
}

variable "ingress_rules" {
  type = list(object(
    {
      description       = optional(string, null)
      from_port         = optional(number, null)
      to_port           = optional(number, null)
      protocol          = optional(string, null)
      cidr_blocks       = optional(list(string), null)
      prefix_list_ids   = optional(list(string), null)
      security_group_id = optional(list(string), null)
      self              = optional(bool, false)
    }
  ))
  default     = []
  description = "Security Group Ingress Rules"
}

variable "egress_rules" {
  type = list(object(
    {
      description       = optional(string, null)
      from_port         = optional(number, null)
      to_port           = optional(number, null)
      protocol          = optional(string, null)
      cidr_blocks       = optional(list(string), null)
      prefix_list_ids   = optional(list(string), null)
      security_group_id = optional(list(string), null)
      self              = optional(bool, false)
    }
  ))
  default     = []
  description = "Security Group Egress Rules"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional Tags to attach to Security Group"
}
