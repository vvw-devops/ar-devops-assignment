module "ec2_instance" {
  source   = "../00-modules/ec2-instance/1.0"
  for_each = var.ec2_instances

  name                          = each.value.name
  subnet_id                     = each.value.subnet_id
  ami_config                    = each.value.ami_config
  ami_id                        = each.value.ami_id
  instance_type                 = each.value.instance_type
  kms_key_id                    = each.value.kms_key_id
  root_volume                   = each.value.root_volume
  block_device_mappings         = each.value.block_device_mappings
  http_put_response_hop_limit   = each.value.http_put_response_hop_limit
  user_data                     = each.value.user_data
  policy_documents              = each.value.policy_documents
  policy_arns                   = each.value.policy_arns
  security_groups               = each.value.security_groups
  sg_rules                      = each.value.sg_rules
  enable_detailed_monitoring    = each.value.enable_detailed_monitoring
  enable_termination_protection = each.value.enable_termination_protection
  prevent_destroy               = each.value.prevent_destroy
  volume_tags                   = each.value.volume_tags

  tags = merge(local.merged_tags, each.value.tags)
}
