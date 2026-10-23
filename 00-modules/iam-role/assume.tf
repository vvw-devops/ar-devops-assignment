data "aws_iam_policy_document" "assume" {
  statement {
    sid     = "AllowAWSAssumeRole"
    actions = ["sts:AssumeRole"]

    dynamic "principals" {
      for_each = toset(length(var.role_arns) > 0 ? ["true"] : [])
      content {
        type        = "AWS"
        identifiers = var.role_arns
      }
    }
    dynamic "principals" {
      for_each = toset(length(var.services) > 0 ? ["true"] : [])
      content {
        type        = "Service"
        identifiers = [for service in var.services : "${service}.amazonaws.com"]
      }
    }
  }
}

data "aws_iam_policy_document" "assume_role" {
  source_policy_documents = [coalesce(var.assume_role_policy_document, data.aws_iam_policy_document.assume.json)]
}