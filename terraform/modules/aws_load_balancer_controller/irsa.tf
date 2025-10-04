# ============================================
# AWS Load Balancer Controller IRSA Setup
# Safe for re-runs (skips if OIDC already exists)
# ============================================

data "aws_caller_identity" "current" {}

# Try to find an existing OIDC provider
data "aws_iam_openid_connect_provider" "existing" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(var.oidc_provider_url, "https://", "")}"
}

# If no provider exists, create one
resource "aws_iam_openid_connect_provider" "eks" {
  count = can(data.aws_iam_openid_connect_provider.existing.arn) ? 0 : 1

  url             = var.oidc_provider_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0ecd4e4e3"]
}

# Determine the final OIDC provider ARN (either existing or newly created)
locals {
  oidc_provider_arn = can(data.aws_iam_openid_connect_provider.existing.arn) ? data.aws_iam_openid_connect_provider.existing.arn : aws_iam_openid_connect_provider.eks[0].arn
}

# IAM Policy for AWS Load Balancer Controller
data "aws_iam_policy_document" "alb_controller" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_role" "alb_controller" {
  name               = "eks-alb-controller"
  assume_role_policy = data.aws_iam_policy_document.alb_controller.json
}

resource "aws_iam_role_policy_attachment" "alb_controller_attach" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLoadBalancerControllerIAMPolicy"
}
