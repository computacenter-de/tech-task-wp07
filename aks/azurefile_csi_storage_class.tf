
# https://docs.cloudbees.com/docs/cloudbees-ci/latest/aks-install-guide/aks-pre-install-requirements#_storage_requirements
# The default storage classes in Azure Files use Common Internet File System
# (CIFS) protocols, which are not compatible with CloudBees CI. Instead, set up a
# new storage class using the Network File System (NFS).
resource "kubernetes_manifest" "azurefile_csi_storage_class" {
  manifest = {
    "apiVersion" = "storage.k8s.io/v1"
    "kind"       = "StorageClass"
    "metadata" = {
      "name" = "azurefile-csi-premium-nfs"
    }
    "provisioner" = "file.csi.azure.com"
    "parameters" = {
      "skuName"  = "Premium_LRS"
      "protocol" = "nfs"
    }
    "reclaimPolicy"       = "Delete"
    "volumeBindingMode"   = "Immediate"
    "allowVolumeExpansion" = true
  }
  depends_on = [module.aks]
}
