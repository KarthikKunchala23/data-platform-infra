# IAM role for Redshift to access S3
resource "aws_iam_role" "redshift_s3_access" {
  name = "${var.namespace_name}-redshift-s3-access"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "redshift-serverless.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "redshift_s3_read" {
  role       = aws_iam_role.redshift_s3_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

output "redshift_role_arn" {
  value = aws_iam_role.redshift_s3_access.arn
}
