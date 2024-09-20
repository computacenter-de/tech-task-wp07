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

Our apporch:

Computacenter is pursuing a solution with the enterprise [CloudBees CI](https://docs.cloudbees.com/docs/cloudbees-ci/latest/architecture/ci-cloud)
instead of open source Jenkins. We are certain that this solution can fulfil
these and many other requirements better and we would like to demonstrate this for
this task. Our goal is to have less effort in the implementation and operation
through the features of an enterprise solution.

