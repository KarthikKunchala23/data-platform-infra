# ============================================
# AWS Load Balancer Controller IRSA Setup
# ============================================
data "aws_caller_identity" "account" {
  
}

# We expect this to be passed from the EKS module
# (e.g., module.eks.cluster_oidc_issuer_url)
locals {
  oidc_provider_url = var.oidc_provider_url
  oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.account.account_id}:oidc-provider/${replace(local.oidc_provider_url, "https://", "")}"
}

# Try to fetch existing OIDC provider, but this data source
# will fail if it doesn't exist, so we wrap in try() below
data "aws_iam_openid_connect_provider" "existing" {
  arn = local.oidc_provider_arn
}

# TLS certificate for thumbprint
data "tls_certificate" "oidc" {
  url = local.oidc_provider_url
}

# Always create OIDC provider if var.create_oidc_provider = true
# (you can set this flag in variables.tf)
resource "aws_iam_openid_connect_provider" "eks" {
  count = var.create_oidc_provider ? 1 : 0

  url             = local.oidc_provider_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
}

# Determine active OIDC ARN (existing or created)
locals {
  active_oidc_provider_arn = var.create_oidc_provider ? aws_iam_openid_connect_provider.eks[0].arn : local.oidc_provider_arn
}

# IAM Role Trust Policy for AWS Load Balancer Controller
data "aws_iam_policy_document" "alb_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.active_oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(local.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

# IAM Role for AWS Load Balancer Controller
resource "aws_iam_role" "alb_controller" {
  name               = "eks-alb-controller"
  assume_role_policy = data.aws_iam_policy_document.alb_assume_role.json
}

# IAM Policy for ALB Controller
resource "aws_iam_policy" "alb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "IAM Policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/alb-controller-policy.json")
}

# Attach the IAM policy to the role
resource "aws_iam_role_policy_attachment" "alb_controller_attach" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}
