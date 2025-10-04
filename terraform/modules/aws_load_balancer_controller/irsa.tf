# ============================================
# AWS Load Balancer Controller IRSA Setup
# ============================================

data "tls_certificate" "oidc" {
  url = var.oidc_provider_url
}

# Try to look up an existing OIDC provider by ARN
data "aws_caller_identity" "current" {}

locals {
  oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(var.oidc_provider_url, "https://", "")}"
}

# Attempt to fetch existing OIDC provider (ignore if not found)
data "aws_iam_openid_connect_provider" "existing" {
  arn = local.oidc_provider_arn
  # Terraform will ignore this if the provider doesn't exist yet
  # This keeps the plan deterministic
}

# Create OIDC provider only if it doesn't exist
resource "aws_iam_openid_connect_provider" "eks" {
  count           = try(length(data.aws_iam_openid_connect_provider.existing.url), 0) > 0 ? 0 : 1
  url             = var.oidc_provider_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.oidc.certificates[0].sha1_fingerprint]
}

# Determine the active OIDC ARN (either existing or just created)
locals {
  active_oidc_provider_arn = try(
    data.aws_iam_openid_connect_provider.existing.arn,
    aws_iam_openid_connect_provider.eks[0].arn
  )
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
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
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
