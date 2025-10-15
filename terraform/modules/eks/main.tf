# Security group for cluster control plane
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-sg"
  vpc_id      = var.vpc_id
  description = "EKS cluster security group"
  tags = { Name = "${var.cluster_name}-sg" }
}

resource "aws_security_group_rule" "eks_cluster_sg_inbound" {
  description              = "Allow all inbound traffic from worker nodes to control plane"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id
  
}
# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs = ["0.0.0.0/0"]
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy
  ]
}

resource "aws_iam_openid_connect_provider" "eks" {
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
}

data "tls_certificate" "oidc" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# -------------------------
# OIDC Provider for IRSA
# -------------------------

data "aws_eks_cluster" "oidc" {
  name = aws_eks_cluster.this.name
}

data "aws_eks_cluster_auth" "oidc" {
  name = aws_eks_cluster.this.name
}

# Node group (managed node group)
resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  instance_types = [var.node_instance_type]
  ami_type = "AL2023_x86_64_STANDARD"

  depends_on = [aws_eks_cluster.this]
}


# -------------------------
# EKS EBS CSI Driver Addon
# -------------------------
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "aws-ebs-csi-driver"
  addon_version = "v1.50.1-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"
  service_account_role_arn = aws_iam_role.eks_addons.arn

  depends_on = [
    aws_iam_role_policy_attachment.ebs_csi_driver_attach,
    aws_eks_cluster.this
  ]
}