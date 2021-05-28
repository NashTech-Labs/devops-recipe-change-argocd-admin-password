# Change Argocd admin password
       
### EKS Cluster having argocd installed and if in case need to change admin password, then use this script to accomplish the task.

prequisites:

```
1. Linux system
2. docker should be installed
3. kubectl
4. aws cli

```

### How to run:
```
chmod +x argocd-admin-passoword-change.sh
./argocd-admin-passoword-change.sh <Cluster-name> <region>
```