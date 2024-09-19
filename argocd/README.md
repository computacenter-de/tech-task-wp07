# ArgoCD

## Setup

After having deployed your AKS cluster via Terraform, install ArgoCD via Helm and connect it to the ArgoCD repository.

Make sure you have the Helm CLI installed locally and that you can connect to your Kubernetes cluster via kubectl.

Run the following command to install ArgoCD:

```bash
helm install argo-cd oci://ghcr.io/argoproj/argo-helm/argo-cd --version 7.5.2 --namespace argo-cd
```

You can monitor the installation via 

```bash
kubectl -n argo-cd get pods -w
```

As soon as the installation is done, retreive your admin password using

```bash
kubectl get secret -n argo-cd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

and connect to ArgoCD via local port forward:

```bash
kubectl port-forward services/argo-cd-argocd-server -n argo-cd 8443:443
```

You can now access the instance via your browser: https://localhost:8443

Log in and create a repository in the settings. Connecting via a project based SSH key is recommended.

Afterwards, you can navigate to "Applications" and create a "New App". Use the repository you just configured and make sure to point to the path `/argocd`.

Attention: Connecting and syncing your applications will also change ArgoCD to be available under the context path `/argocd/`. It will also create an ingress ressource so that ArgoCD is available publicly!

After the sync is done, you can connect to your CloudBees Jenkins Operations Center (CJOC) via the public domain and the context path `/cjoc/`
