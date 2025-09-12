# --------------------------
# Outputs
# --------------------------

output "airflow_irsa_role_arn" {
  description = "IAM Role ARN for Airflow IRSA"
  value       = aws_iam_role.airflow_irsa.arn
}

output "airflow_logs_bucket" {
  description = "S3 bucket name for Airflow logs"
  value       = aws_s3_bucket.airflow_logs.bucket
}
