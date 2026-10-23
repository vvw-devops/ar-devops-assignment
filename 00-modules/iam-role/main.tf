# Role
resource "aws_iam_role" "role" {
  name                 = local.name
  name_prefix          = local.name_prefix
  description          = var.description
  path                 = var.path
  assume_role_policy   = data.aws_iam_policy_document.assume_role.json
  max_session_duration = var.max_session_duration
  permissions_boundary = var.permissions_boundary

  force_detach_policies = true

  tags = merge(var.tags, { Name = var.name })
}

# Instance Profile
resource "aws_iam_instance_profile" "profile" {
  for_each = toset(var.create_instance_profile ? ["true"] : [])

  name        = local.name
  name_prefix = local.name_prefix
  path        = var.path
  role        = aws_iam_role.role.name
  tags        = merge(var.tags, { Name = var.name })
}

# Policy ARN Attachments
resource "aws_iam_role_policy_attachment" "policy" {
  for_each = toset(var.policy_arns)

  role       = aws_iam_role.role.id
  policy_arn = each.key
}

# Custom Policy Documents
data "aws_iam_policy_document" "merged" {
  source_policy_documents = var.policy_documents
}

resource "aws_iam_policy" "policy" {
  for_each = local.has_custom_policies

  name        = local.name
  name_prefix = local.name_prefix
  path        = "/"
  policy      = data.aws_iam_policy_document.merged.json

  description = "A policy for the ${var.name} role."

  tags = merge(var.tags,
    { Name = var.name }
  )
}

resource "aws_iam_role_policy_attachment" "custom" {
  for_each = local.has_custom_policies

  role       = aws_iam_role.role.id
  policy_arn = aws_iam_policy.policy[each.key].arn
}
