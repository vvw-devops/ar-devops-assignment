# IAM Role and Instance Profile
module "instance_role" {
  source = "../../iam-role/1.0"

  name                    = "${var.name}-${local.region}-role"
  description             = "IAM Role for ${var.name} Instance"
  services                = ["ec2"]
  create_instance_profile = true

  policy_arns = setunion([
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ], var.policy_arns)

  policy_documents = var.policy_documents

  tags = var.tags
}