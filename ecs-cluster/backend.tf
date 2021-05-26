terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "nawinkumar94"

    workspaces {
      prefix = "ecs-cluster-"
    }
  }
}

variable "TFC_WORKSPACE_NAME" {
  type    = string
  default = ""
}

locals {
  # If your backend is not Terraform Cloud, the value is ${terraform.workspace}
  # otherwise the value retrieved is that of the TFC_WORKSPACE_NAME with trimprefix
  workspace = var.TFC_WORKSPACE_NAME != "" ? trimprefix(var.TFC_WORKSPACE_NAME, "ecs-cluster-") : terraform.workspace
}
