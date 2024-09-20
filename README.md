# Tech Task WP07 Jenkins aka CloudBees CI by Computacenter

## Requirements and analysis

Jenkins instance setup and security management on Kubernetes

Objective:

To set up a Jenkins instance with dummy jobs on Kubernetes, back it up, and
handle a security breach scenario using Terraform, Ansible, or similar tools.
The deployment will be done in Azure using AKS (Azure Kubernetes Service).

1. Create a Jenkins Instance with Dummy Jobs on Kubernetes
 - [X] Set up an AKS cluster in Azure.
    - [AKS setup README](aks/README.md)
 - [X] Deploy a Jenkins instance on the AKS cluster.
    - [Argo CD setup README](argocd/README.md)
    - [CloudBees setup README](cloudbees-ci/README.md)
 - [X] Create several dummy jobs in Jenkins to simulate a real environment.

2. Backup the Instance and Validate the Backup

Implement a backup strategy for the Jenkins instance. Validate that the backup
is complete and can be restored successfully.

3. Security Breach Scenario: Master Key Exposure
 - [ ] Make the Instance Unavailable to Others
   - [ ] Scale down the Jenkins deployment to zero replicas.
   - [ ] Alternatively, remove the route to the Jenkins service or block access using a proxy.
 - [ ] Rotate the Master Key
   - [ ] Generate a new master key for Jenkins.
   - [ ]  Update the Jenkins configuration with the new master key.
 - [ ] Re-encrypt All Credentials
   - [ ] Re-encrypt all stored credentials in Jenkins using the new master key.
- [ ] Make the Instance Available to Others
  - [ ] Scale the Jenkins deployment back up.
  - [ ] Restore the route to the Jenkins service or unblock access via the proxy.
- [ ] Validate that the Jobs are Still Working
  - [ ] Ensure all dummy jobs are functioning correctly after the security changes.

## Our apporch:

Computacenter is pursuing a solution with the enterprise [CloudBees CI](https://docs.cloudbees.com/docs/cloudbees-ci/latest/architecture/ci-cloud)
instead of open source Jenkins. We are certain that this solution can fulfil
these and many other requirements better and we would like to demonstrate this for
this task. Our goal is to have less effort in the implementation and operation
through the features of an enterprise solution.

### 1. Create a Jenkins Instance with Dummy Jobs on Kubernetes

Our approach is to provide everything as code and automate as much as possible.
For this task, we have chosen to set up the Azure infrastructure AKS with
Terraform. We decided to adopt ArgoCD for the central deployment of the
[CloudBees Operation Centre](https://docs.cloudbees.com/docs/cloudbees-ci/latest/architecture/ci-cloud).
The CloudBees controllers (Jenkins instances for the teams) can be automated or provisioned with a mouse click. However, we also
wanted to take the GitOps approach for the CloudBees Operation Centre.

The following diagram shows how the architecture works and how the controllers
(Jenkins team instances) are provisioned, configured and controlled by the
CloudBees Operation Centre.
![CloudBees Operation Centre AKS Overview](./images/cbci-overview.png)


Many software systems use secret data for authentication, e.g. user passwords,
secret keys, access tokens and certificates.

These can of course be stored in a Jenkins Credentials Store. However, this has
the consequence that as soon as the master.key is stolen. All credentials are
directly compromised.

Our approach was to use an Azure KeyVault to manage the important credentials
that can be accessed via an Azure Service Principal. This Azure Service
Principal only gets READ-only rights and only from the controller. This would
mean that each development team would be assigned one Azure Service Principal
per Jenkins, including its own Azure KeyVault.

This was not requested in the ‘Tech Task’. Was implemented by us with minimal
effort. In order to map the tasks (although they certainly involve a great
security risk from our point of view), for example, we store a simple secret in
the Jenkins Credentials Store of the respective controller.

Below is an example image of what this looks like and was partially implemented
by us.

![Key Vault Setup](./images/keyvault-setup.png)

Due to time and resource constraints and as it is not a requirement of the Tech
Task, we have not built this High Availability (active/active). Since CloudBees
supports this out-of-box, it would be possible in this setup with little
effort. More about this here:
[High Availability (active/active) docs](https://docs.cloudbees.com/docs/cloudbees-ci/latest/ha/ha-fundamentals)

### 2. Backup the Instance and Validate the Backup

https://docs.cloudbees.com/docs/cloudbees-ci/latest/backup-restore/cloudbees-backup-plugin

### 3. Security Breach Scenario: Master Key Exposure

