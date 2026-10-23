resource "aws_security_group" "this" {
  name        = local.name
  name_prefix = local.name_prefix
  description = var.description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = length(var.ingress_rules) > 0 ? var.ingress_rules : []
    content {
      description     = ingress.value.description
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      prefix_list_ids = ingress.value.prefix_list_ids
      security_groups = ingress.value.security_group_id
      self            = ingress.value.self
    }
  }

  dynamic "egress" {
    for_each = length(var.egress_rules) > 0 ? var.egress_rules : []
    content {
      description     = egress.value.description
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      cidr_blocks     = egress.value.cidr_blocks
      prefix_list_ids = egress.value.prefix_list_ids
      security_groups = egress.value.security_group_id
      self            = egress.value.self
    }
  }

  tags = merge(var.tags, { Name = var.name })

  lifecycle {
    create_before_destroy = true
  }
}
