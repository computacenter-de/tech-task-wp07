resource "kubernetes_namespace_v1" "example" {
  metadata {
    name = "example"
  }

  depends_on = [module.aks]
}


