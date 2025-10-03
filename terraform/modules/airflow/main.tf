# --------------------------
# IRSA Role for Airflow
# --------------------------

resource "aws_iam_role" "airflow_irsa" {
  name = "${var.name_prefix}-airflow-irsa"

  assume_role_policy = data.aws_iam_policy_document.airflow_irsa_assume.json
}

data "aws_iam_policy_document" "airflow_irsa_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn] # from EKS OIDC provider
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:airflow:airflow"]
    }
  }
}

# --------------------------
# S3 Bucket for Airflow Logs
# --------------------------

resource "aws_s3_bucket" "airflow_logs" {
  bucket        = "${var.name_prefix}-airflow-logs"
  force_destroy = true

  tags = {
    Name = "${var.name_prefix}-airflow-logs"
  }
}

# Optional: Enable versioning
resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.airflow_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Optional: Default encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.airflow_logs.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# --------------------------
# IAM Policy for Airflow to use S3 + SecretsManager + Redshift
# --------------------------

resource "aws_iam_role_policy" "airflow_access" {
  name = "${var.name_prefix}-airflow-access"
  role = aws_iam_role.airflow_irsa.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
        Resource = [
          aws_s3_bucket.airflow_logs.arn,
          "${aws_s3_bucket.airflow_logs.arn}/*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "redshift-data:ExecuteStatement",
          "redshift-data:GetStatementResult",
          "redshift-data:DescribeStatement"
        ]
        Resource = "*"
      }
    ]
  })
}