# ServiceAccount with IRSA annotation
# resource "kubernetes_service_account" "this" {
#   metadata {
#     name      = "aws-load-balancer-controller"
#     namespace = "kube-system"
#     annotations = {
#       "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller.arn
#     }
#   }
# }


# # Helm release for ALB Controller
# resource "helm_release" "this" {
#   name       = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"

#   set = [
#     {
#     name  = "clusterName"
#     value = var.cluster_name
#    },
#    {
#     name  = "region"
#     value = var.region
#    },
#    {
#     name  = "vpcId"
#     value = var.vpc_id
#   }, 
#   {
#     name  = "serviceAccount.create"
#     value = "false"
#   },
#   {
#     name  = "serviceAccount.name"
#     value = kubernetes_service_account.this.metadata[0].name
#   }
# ]

#   depends_on = [kubernetes_service_account.this]
# }
