locals {
  sa_subject = "system:serviceaccount:${var.namespace}:${var.service_account}"
}

data "aws_iam_policy_document" "assume_oidc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_arn, "arn:aws:iam::[0-9]+:oidc-provider/", "")}:sub"
      values   = [local.sa_subject]
    }
  }
}

resource "aws_iam_role" "irsa" {
  name               = "${var.name_prefix}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_oidc.json
  description        = "IRSA role for ${var.name_prefix}"
}

# Attach S3 and SecretsManager inline policy
data "aws_iam_policy_document" "airflow_access" {
  statement {
    sid    = "S3Access"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = concat(var.s3_bucket_arns, [for arn in var.s3_bucket_arns : "${arn}/*"])
  }

  statement {
    sid    = "SecretsManagerAccess"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = ["arn:aws:secretsmanager:*:*:secret:airflow/*"]
  }
}

resource "aws_iam_role_policy" "airflow_policy" {
  name   = "${var.name_prefix}-policy"
  role   = aws_iam_role.irsa.id
  policy = data.aws_iam_policy_document.airflow_access.json
}

output "role_arn" {
  value = aws_iam_role.irsa.arn
}
