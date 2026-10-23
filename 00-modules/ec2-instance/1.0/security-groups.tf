module "instance_sg" {
  source = "../../security-groups/1.0"

  name          = var.name
  description   = "Instance SG - ${var.name}"
  vpc_id        = data.aws_subnet.selected.vpc_id
  ingress_rules = var.sg_rules.ingress
  egress_rules  = var.sg_rules.egress
}