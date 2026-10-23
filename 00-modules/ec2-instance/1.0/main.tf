# Instance
resource "aws_instance" "instance" {
  for_each = toset(var.prevent_destroy ? [] : ["true"])

  ami                     = local.ami_id
  instance_type           = var.instance_type
  subnet_id               = var.subnet_id
  user_data_base64        = local.user_data_base64
  ebs_optimized           = local.ebs_optimized
  monitoring              = var.enable_detailed_monitoring
  key_name                = aws_key_pair.ec2_key.key_name
  iam_instance_profile    = module.instance_role.iam_instance_profile_id
  vpc_security_group_ids  = concat([module.instance_sg.id], var.security_groups)
  disable_api_termination = var.enable_termination_protection

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = var.http_put_response_hop_limit
    instance_metadata_tags      = "disabled"
  }

  root_block_device {
    encrypted  = true
    kms_key_id = var.kms_key_id

    delete_on_termination = true
    volume_size           = var.root_volume.size
    volume_type           = var.root_volume.type
    iops                  = var.root_volume.iops
    throughput            = var.root_volume.throughput

    tags = merge(coalesce(var.volume_tags, var.tags), {
      Name = "${var.name}-root"
      name = "${var.name}-root"
    })
  }

  dynamic "ebs_block_device" {
    for_each = var.block_device_mappings
    content {
      encrypted  = true
      kms_key_id = var.kms_key_id

      device_name = ebs_block_device.value.device_name
      volume_size = ebs_block_device.value.volume_size
      volume_type = ebs_block_device.value.volume_type
      iops        = ebs_block_device.value.iops
      throughput  = ebs_block_device.value.throughput

      delete_on_termination = ebs_block_device.value.delete_on_termination

      tags = merge(coalesce(var.volume_tags, var.tags), {
        Name = "${var.name}-secondary-vol"
        name = "${var.name}-secondary-vol"
      })
    }
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}


# Protected Instance
resource "aws_instance" "protected" {
  for_each = toset(var.prevent_destroy ? ["true"] : [])

  ami                     = local.ami_id
  instance_type           = var.instance_type
  subnet_id               = var.subnet_id
  user_data_base64        = local.user_data_base64
  ebs_optimized           = local.ebs_optimized
  monitoring              = var.enable_detailed_monitoring
  key_name                = aws_key_pair.ec2_key.key_name
  iam_instance_profile    = module.instance_role.iam_instance_profile_id
  vpc_security_group_ids  = concat([module.instance_sg.id], var.security_groups)
  disable_api_termination = var.enable_termination_protection

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = var.http_put_response_hop_limit
    instance_metadata_tags      = "disabled"
  }

  root_block_device {
    encrypted  = true
    kms_key_id = var.kms_key_id

    delete_on_termination = true
    volume_size           = var.root_volume.size
    volume_type           = var.root_volume.type
    iops                  = var.root_volume.iops
    throughput            = var.root_volume.throughput

    tags = merge(coalesce(var.volume_tags, var.tags), {
      Name = "${var.name}-root"
    })
  }

  dynamic "ebs_block_device" {
    for_each = var.block_device_mappings
    content {
      encrypted  = true
      kms_key_id = var.kms_key_id

      device_name = ebs_block_device.value.device_name
      volume_size = ebs_block_device.value.volume_size
      volume_type = ebs_block_device.value.volume_type
      iops        = ebs_block_device.value.iops
      throughput  = ebs_block_device.value.throughput

      delete_on_termination = ebs_block_device.value.delete_on_termination

      tags = merge(coalesce(var.volume_tags, var.tags), {
        Name = "${var.name}-secondary-vol"
      })
    }
  }

  tags = merge(var.tags, {
    Name = var.name
  })

  lifecycle {
    prevent_destroy = true
  }
}
