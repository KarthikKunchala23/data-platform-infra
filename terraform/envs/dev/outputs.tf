output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "ecr_repo_url" {
  value = module.ecr.repository_url
}

output "s3_raw_bucket" {
  value = module.s3_data.raw_bucket_name
}

output "airflow_irsa_role_arn" {
  value = module.airflow.airflow_irsa_role_arn
}

output "airflow_logs_bucket" {
  value = module.airflow.airflow_logs_bucket
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.eks_oidc.arn
}

output "cluster_oidc_issuer" {
  value = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}
