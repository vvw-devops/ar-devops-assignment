locals {
  name        = var.use_name_as_prefix ? null : var.name
  name_prefix = var.use_name_as_prefix ? "${var.name}-" : null
}