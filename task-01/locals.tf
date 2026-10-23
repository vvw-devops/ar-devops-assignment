locals {
  common_tags = {
    Environment = var.environment
    Owner       = "devops@example.com"
    ManagedBy   = "Terraform"
  }

  merged_tags = merge(local.common_tags, var.tags)
}
