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
