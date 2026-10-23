# RSA 4096-bit private key
resource "tls_private_key" "ec2_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# EC2 Key Pair
resource "aws_key_pair" "ec2_key" {
  key_name   = "${var.name}-kp"
  public_key = tls_private_key.ec2_ssh_key.public_key_openssh
}

# AWS Secrets Manager to store the private key
resource "aws_secretsmanager_secret" "ec2_private_key_secret" {
  name                    = "ec2/kp/${var.name}-kp"
  description             = "Private key for the ${var.name} EC2 instances"
  recovery_window_in_days = 0
}

# Store the actual private key PEM content inside the Secret
resource "aws_secretsmanager_secret_version" "ec2_private_key_value" {
  secret_id     = aws_secretsmanager_secret.ec2_private_key_secret.id
  secret_string = tls_private_key.ec2_ssh_key.private_key_pem
}
