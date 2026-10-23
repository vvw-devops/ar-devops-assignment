variable "name" {
  type        = string
  description = "The name of the EC2 instance to create."
}

variable "subnet_id" {
  type        = string
  description = "The subnet in which to deploy the instance."
}

variable "ami_config" {
  type = object({
    owners = optional(list(string))
    name   = optional(list(string))
    arch   = optional(list(string))
  })
  description = "AMI Configuration filters to use in case ami_id is not passed."
  default = {
    owners = ["amazon"]
    name   = ["al2023-ami-2023*"]
    arch   = ["arm64"]
  }
}

variable "ami_id" {
  type        = string
  description = "AMI ID will be used if provided; otherwise, ami_config filters will be applied."
  default     = null
}

variable "instance_type" {
  type        = string
  description = "The type of the instance to create."
  default     = "t4g.micro"
}

variable "kms_key_id" {
  type        = string
  default     = null
  description = "The KMS key used to encrypt the volumes."
}

variable "root_volume" {
  type = object({
    size       = optional(number)
    type       = optional(string)
    iops       = optional(number)
    throughput = optional(number)
  })
  description = <<-EOT
    - size: The size (in GiB) of the root volume.
    - type: The type of volume for root block device.
    - iops: Amount of provisioned IOPS for root block device.
    - throughput :Throughput to provision for a volume in megabytes per second for root block device.
  EOT
  default = {
    size       = null
    type       = null
    iops       = null
    throughput = null
  }
}

variable "block_device_mappings" {
  type = map(object({
    device_name           = optional(string, null)
    volume_size           = optional(number, null)
    volume_type           = optional(string, null)
    iops                  = optional(number, null)
    throughput            = optional(number, null)
    delete_on_termination = optional(bool, true)
  }))
  description = "Additional EBS Volume to attach to EC2 instance."
  default     = {}
}

variable "http_put_response_hop_limit" {
  type        = number
  default     = 1
  description = <<-EOT
    The desired HTTP PUT response hop limit for instance metadata requests (IMDSv2).
    This controls how far the metadata token can travel through network hops.

    Valid values: 1 to 3.
    - Set to `1` for standard EC2 instances where applications run directly on the host.
    - Set to `2` if running containerized workloads (e.g., Docker, ECS, EKS) on the instance,
      as the container network adds an additional routing hop between the container and IMDS.

    Increasing this value allows metadata requests to traverse more network layers but may
    reduce security by allowing metadata access from further network distances.
  EOT
}

variable "user_data" {
  type        = string
  default     = null
  description = "The user data script file for the instance."
}

variable "policy_documents" {
  type        = list(string)
  default     = []
  description = "The list of iam policy documents to apply to the instance execution role."
}

variable "policy_arns" {
  type        = set(string)
  default     = []
  description = <<-EOT
    The set of pre-existing iam policy arns for the instance execution role.
    Use only pre-existing policies.
  EOT  
}

variable "security_groups" {
  type        = list(string)
  default     = []
  description = "A list of additional security group IDs to associate with the instance."
}

variable "sg_rules" {
  type = object({
    ingress = list(object({
      description       = optional(string, null)
      from_port         = optional(number, null)
      to_port           = optional(number, null)
      protocol          = optional(string, null)
      cidr_blocks       = optional(list(string), null)
      prefix_list_ids   = optional(list(string), null)
      security_group_id = optional(list(string), null)
      self              = optional(bool, false)
    }))
    egress = list(object({
      description       = optional(string, null)
      from_port         = optional(number, null)
      to_port           = optional(number, null)
      protocol          = optional(string, null)
      cidr_blocks       = optional(list(string), null)
      prefix_list_ids   = optional(list(string), null)
      security_group_id = optional(list(string), null)
      self              = optional(bool, false)
    }))
  })
  default = {
    ingress = []
    egress  = []
  }
  description = "Security Group Rules to add to the instance's security group which gets created as part of module resources."
}

variable "enable_detailed_monitoring" {
  type        = bool
  default     = false
  description = "A value indicating whether or not to enable detailed monitoring, which incurs additional costs."
}

variable "enable_termination_protection" {
  type        = bool
  default     = false
  description = "When true, the instance is created with API termination protection enabled."
}

variable "prevent_destroy" {
  type        = bool
  default     = false
  description = "When true, the instance is created with lifecycle.prevent_destroy so Terraform refuses to destroy it."
}

variable "volume_tags" {
  type        = map(string)
  default     = null
  description = "A map of tags to apply to the EBS volumes associated with the EC2 instance."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to attach to module resources."
}
