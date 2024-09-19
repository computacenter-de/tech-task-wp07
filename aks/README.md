# Setting up Azure Kubernetes Service (AKS) with Terraform for Tech Task WP07

To set up the AKS cluster, we have decided to use the [Terraform Module for
deploying an AKS cluster](https://github.com/Azure/terraform-azurerm-aks) and
the following example: [application_gateway_ingress](https://github.com/Azure/terraform-azurerm-aks/tree/main/examples/application_gateway_ingress).

We opted for this solution in order to quickly implement the AKS Cluster  but
not to compromise on best practices. The following is our approach. The
corresponding Terraform code can be found in the aks folder.

## Prerequisites

- Install [Terraform](https://www.terraform.io/downloads.html)
- Install the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Ensure you have proper permissions in your Azure subscription (Owner or Contributor role)

## Security Considerations

- **RBAC:** Enabling Role-Based Access Control (RBAC) for AKS to ensure proper access control.
- **Azure Active Directory (AAD):** Integrate AAD for secure authentication.
- **Premium Disks:** Use instance types that allow premium disks to improve performance and reliability.
- **Private Cluster (Optional):** Restrict access to the API server with a private cluster.
- **Azure Container Registry (ACR):** Attach ACR to ensure secure access to container images.
- **Network Policies:** Ensure network security between pods and external resources.

### Initialize and Apply Terraform Configuration

   ```bash
    terraform init
    # Create a Service Principal (or you can skip this if you already have one)
    SP=$(az ad sp create-for-rbac --name "wp07-couldbees-sp" --role contributor --scopes /subscriptions/$(az account show --query id -o tsv))

    # Extract the necessary values from the JSON output
    ARM_CLIENT_ID=$(echo $SP | jq -r '.appId')
    ARM_CLIENT_SECRET=$(echo $SP | jq -r '.password')
    ARM_TENANT_ID=$(echo $SP | jq -r '.tenant')
    ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)

    # Export the environment variables for the current session
    export ARM_CLIENT_ID ARM_CLIENT_SECRET ARM_TENANT_ID ARM_SUBSCRIPTION_ID

    # Output the variables to verify
    echo "ARM_CLIENT_ID=$ARM_CLIENT_ID"
    echo "ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET"
    echo "ARM_TENANT_ID=$ARM_TENANT_ID"
    echo "ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID"

    terraform plan
    terraform apply
   ```

## Verification

To verify the setup:

1. **Access AKS Cluster**:

   Get credentials for your AKS cluster:

   ```bash
   az aks get-credentials --resource-group aks-resource-group --name aks-cluster
   kubectl get nodes
   ```

2. **Check Namespace and Storage Class**:

   ```bash
   kubectl get namespace
   kubectl describe storageclass default-storageclass
   ```
## Security Enhancements

1. **RBAC and AAD**: By enabling RBAC and integrating with AAD, we ensure that only authenticated and authorized users can access the AKS cluster.
2. **Managed Identity**: The AKS cluster uses a system-assigned managed identity for secure interaction with Azure resources (e.g., ACR).
3. **Premium Disks**: Using the `Standard_D4s_v3` instance type ensures that premium disks are available, which are more secure and reliable for workloads requiring persistent storage.

## Key Configuration Details

- **Node Pool**: The node pool configuration specifies `Standard_D4s_v3` as the VM size, ensuring at least 2 CPUs and 4 GiB of memory per node, with support for premium disks.
- **RBAC & AAD**: RBAC is enabled with Azure Active Directory integration for enhanced authentication and authorization.
- **Azure Container Registry (ACR)**: The AKS cluster is integrated with an ACR to securely pull container images.
- **Storage Class**: A default storage class using Azure Premium disks is defined to support high-performance workloads like CloudBees CI.

## AKS Steup Conclusion

