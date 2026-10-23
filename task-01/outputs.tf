output "instances" {
  value = module.ec2_instance
}

output "name_id_map" {
  description = "Map of instance names to EC2 instance IDs."
  value = {
    for instance in module.ec2_instance : instance.name => instance.id
  }
}

output "name_private_ip_map" {
  description = "Map of instance names to private IP addresses."
  value = {
    for instance in module.ec2_instance : instance.name => instance.private_ip
  }
}
