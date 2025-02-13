variable "mgc_region" {
  description = "Região para o cluster Kubernetes. Opções válidas: br-ne1, br-se1"
  type        = string
  validation {
    condition     = contains(["br-ne1", "br-se1"], var.mgc_region)
    error_message = "Região inválida. Escolha entre: br-ne1, br-se1."
  }
}
