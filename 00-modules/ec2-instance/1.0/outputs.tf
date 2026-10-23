output "name" {
  value       = local.instance.tags.Name
  description = "Instance name (tag - Name)"
}
output "id" {
  value       = local.instance.id
  description = "The identifier for the instance."
}

output "arn" {
  value       = local.instance.arn
  description = "The ARN of the instance."
}

output "network_interface_id" {
  value       = local.instance.primary_network_interface_id
  description = "The id of the primary network interface of the instance."
}

output "private_ip" {
  value       = local.instance.private_ip
  description = "The private ip address assigned to the instance."
}

output "role" {
  value       = module.instance_role
  description = "The role associated with the instance, which will have SSM enabled by default."
}

output "instance_sg" {
  value       = module.instance_sg
  description = "The security group associated with the instance."
}
