locals {
  region = data.aws_region.current.region

  ami_id = var.ami_id != null && var.ami_id != "" ? var.ami_id : data.aws_ami.selected.id

  user_data_base64 = var.user_data != null ? base64encode(file(var.user_data)) : null

  ebs_optimized = contains(["supported", "default"], lower(data.aws_ec2_instance_type.type.ebs_optimized_support))

  # Used to output the instance details in the outputs.tf file
  instance = one(concat(
    values(aws_instance.instance),
    values(aws_instance.protected),
  ))
}