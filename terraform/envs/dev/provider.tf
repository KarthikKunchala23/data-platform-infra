
provider "aws" {
region = var.region
}


// Filled after EKS is created and OIDC known
provider "kubernetes" {
host = module.eks.cluster_endpoint
cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
token = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
kubernetes = {
host = module.eks.cluster_endpoint
cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
token = data.aws_eks_cluster_auth.this.token
}
}

data "aws_eks_cluster_auth" "this" {
name = module.eks.cluster_name
}