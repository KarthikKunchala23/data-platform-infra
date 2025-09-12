resource "kubernetes_config_map" "argocd_cm" {
  metadata {
    name      = "argocd-cm"
    namespace = var.namespace
  }

  data = {
    "accounts.${var.account_name}"         = var.account_capabilities
    "accounts.${var.account_name}.enabled" = tostring(var.enable_account)
  }
}

resource "kubernetes_config_map" "argocd_rbac_cm" {
  metadata {
    name      = "argocd-rbac-cm"
    namespace = var.namespace
  }

  data = {
    "policy.csv" = var.rbac_policies
    "scopes"     = var.rbac_scopes
  }
}
