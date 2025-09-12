# variables.tf

variable "namespace" {
  type        = string
  description = "Namespace where Argo CD is installed"
  default     = "argocd"
}

variable "account_name" {
  type        = string
  description = "Argo CD local account name for CI/CD"
  default     = "github-actions"
}

variable "account_capabilities" {
  type        = string
  description = "Capabilities for the Argo CD account (comma separated)"
  default     = "login,apiKey"
}

variable "enable_account" {
  type        = bool
  description = "Enable the Argo CD local account"
  default     = true
}

variable "rbac_policies" {
  type        = string
  description = "CSV-formatted RBAC policies for the account"
  default = <<EOT
# Allow the account to sync ALL applications in the default project
p, proj:default, applications, sync, *, allow
# Allow the account to view apps
p, proj:default, applications, get, *, allow
# Map the account to role
g, github-actions, role:admin
EOT
}

variable "rbac_scopes" {
  type        = string
  description = "Scopes enabled for Argo CD RBAC"
  default     = "[groups,accounts]"
}
