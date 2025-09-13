
output "cluster_name" {
  value = aws_eks_cluster.this.name
}
output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}
output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}
output "cluster_security_group_id" {
  value = aws_security_group.eks_cluster_sg.id
}

output "cluster_oidc_issuer" {
  description = "OIDC issuer URL for the EKS cluster"
  value       = data.aws_eks_cluster.oidc.identity[0].oidc[0].issuer
}
