resource "kubernetes_config_map_v1_data" "argocd_cm_patch" {
  metadata {
    name      = "argocd-cm"
    namespace = var.namespace
  }

  data = {
    "accounts.${var.account_name}"         = var.account_capabilities
    "accounts.${var.account_name}.enabled" = tostring(var.enable_account)
  }

  force = true
}

resource "kubernetes_config_map_v1_data" "argocd_rbac_patch" {
  metadata {
    name      = "argocd-rbac-cm"
    namespace = var.namespace
  }

  data = {
    "policy.csv" = var.rbac_policies
    "scopes"     = var.rbac_scopes
  }

  force = true
}
