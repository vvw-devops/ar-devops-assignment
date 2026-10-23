output "id" {
  value       = aws_iam_role.role.id
  description = "The name of the role."
}

output "unique_id" {
  value       = aws_iam_role.role.unique_id
  description = "The stable and unique string identifying the role."
}

output "arn" {
  value       = aws_iam_role.role.arn
  description = "The Amazon Resource Name (ARN) of the role."
}

output "max_session_duration" {
  value       = aws_iam_role.role.max_session_duration
  description = "The maximum duration (in seconds) that a role session is valid."
}

output "iam_instance_profile_id" {
  value       = var.create_instance_profile ? aws_iam_instance_profile.profile["true"].id : null
  description = "IAM Instance profile ID."
}

output "iam_instance_profile_arn" {
  value       = var.create_instance_profile ? aws_iam_instance_profile.profile["true"].arn : null
  description = "IAM Instance profile ARN."
}
