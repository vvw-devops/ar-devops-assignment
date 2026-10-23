# Region
data "aws_region" "current" {}

# Subnet
data "aws_subnet" "selected" {
  id = var.subnet_id
}

# EC2 Instance Type
data "aws_ec2_instance_type" "type" {
  instance_type = var.instance_type
}

# AMI
data "aws_ami" "selected" {
  most_recent = true
  owners      = var.ami_config.owners
  filter {
    name   = "name"
    values = var.ami_config.name
  }
  filter {
    name   = "architecture"
    values = var.ami_config.arch
  }
}