# provider "vault" {
#   address = "https://vault-internal.pdevops78.online:8200"
#   skip_tls_verify = true
#   token = var.vault_token
# }

provider "kubernetes" {
  config_path = "~/.kube/config"
}
terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.8.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.11.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}






