variable "account_id" {
  description = "AWS account ID to deploy resources in"
  type        = string
  default     = ""
}

variable "region" {
  description = "value of the AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "ec2_instances" {
  description = "map of instances to create. For details about each input values within the object, refer to the EC2 instance module documentation."
  type = map(object({
    name      = string
    subnet_id = string

    ami_config = optional(object({
      owners = optional(list(string))
      name   = optional(list(string))
      arch   = optional(list(string))
      }), {
      owners = ["amazon"]
      name   = ["al2023-ami-2023*"]
      arch   = ["arm64"]
    })
    ami_id        = optional(string)
    instance_type = optional(string, "t4g.micro")
    kms_key_id    = optional(string)

    root_volume = optional(object({
      size       = optional(number)
      type       = optional(string)
      iops       = optional(number)
      throughput = optional(number)
    }), {})

    block_device_mappings = optional(map(object({
      device_name           = optional(string)
      volume_size           = optional(number)
      volume_type           = optional(string)
      iops                  = optional(number)
      throughput            = optional(number)
      delete_on_termination = optional(bool, true)
    })), {})

    http_put_response_hop_limit = optional(number, 1)
    user_data                   = optional(string)
    policy_documents            = optional(list(string), [])
    policy_arns                 = optional(set(string), [])
    security_groups             = optional(list(string), [])

    sg_rules = optional(object({
      ingress = optional(list(object({
        description       = optional(string)
        from_port         = optional(number)
        to_port           = optional(number)
        protocol          = optional(string)
        cidr_blocks       = optional(list(string))
        prefix_list_ids   = optional(list(string))
        security_group_id = optional(list(string))
        self              = optional(bool, false)
      })), [])
      egress = optional(list(object({
        description       = optional(string)
        from_port         = optional(number)
        to_port           = optional(number)
        protocol          = optional(string)
        cidr_blocks       = optional(list(string))
        prefix_list_ids   = optional(list(string))
        security_group_id = optional(list(string))
        self              = optional(bool, false)
      })), [])
    }), {})

    enable_detailed_monitoring    = optional(bool, false)
    enable_termination_protection = optional(bool, false)
    prevent_destroy               = optional(bool, false)
    volume_tags                   = optional(map(string))
    tags                          = optional(map(string), {})
  }))
  default = {}
}
