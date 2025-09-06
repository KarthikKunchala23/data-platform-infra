output "raw_bucket_name" {
  value = aws_s3_bucket.raw.id
}
output "raw_bucket_arn" {
  value = aws_s3_bucket.raw.arn
}
output "configs_bucket_name" {
  value = aws_s3_bucket.configs.id
}
output "configs_bucket_arn" {
  value = aws_s3_bucket.configs.arn
}
output "airflow_logs_bucket_name" {
  value = aws_s3_bucket.airflow_logs.id
}
output "airflow_logs_bucket_arn" {
  value = aws_s3_bucket.airflow_logs.arn
}