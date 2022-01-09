# FluxCD V2 Configuration

- Install Flux V2 using below command -
  ```
  curl -s https://fluxcd.io/install.sh | sudo bash
  ```
- Check the cluster prerequisites

  ```
  flux check --pre
  ```

- Since FluxCDV2 manages itself in gitops, we have to use the bootstrap command.

  ```
  flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=fleet-infra \
  --branch=main \
  --path=./clusters/my-cluster \
  --personal
  ```

- Clone the Repository containing manifests for Flux

  ```
  git clone https://github.com/$GITHUB_USER/fleet-infra

  cd fleet-infra
  ```

- For telling flux to monitor a git repository, we have to create source -

  ```
  flux create source git podinfo \
  --url=https://github.com/stefanprodan/podinfo \
  --branch=master \
  --interval=30s \
  --export > ./clusters/my-cluster/podinfo-source.yaml

  git add -A && git commit -m "Add podinfo GitRepository"

  git push
  ```

- For syncing & deploying the changes from the source, we will have to create customization for our application from that source.

  ```
  flux create kustomization podinfo \
  --source=podinfo \
  --path="./kustomize" \
  --prune=true \
  --validation=client \
  --interval=5m \
  --export > ./clusters/my-cluster/podinfo-kustomization.yaml

  git add -A && git commit -m "Add podinfo Kustomization"

  git push
  ```

In about, 30 sec… flux will sync the changes from source.

```
flux get kustomizations --watch

NAME        READY   MESSAGE
flux-system True    Applied revision: main/fc07af652d3168be329539b30a4c3943a7d12dd8
podinfo     True    Applied revision: master/855f7724be13f6146f61a893851522837ad5b634
```

- If a Kubernetes manifest is removed from the podinfo repository, Flux will remove it from your cluster.

- If you delete a Kustomization from the fleet-infra repository, Flux will remove all Kubernetes objects that were previously applied from that Kustomization.
- If you alter the podinfo deployment using kubectl edit, the changes will be reverted to match the state described in Git.

- When dealing with an incident, you can pause the reconciliation of a kustomization with

  ```
  flux suspend kustomization <name>
  ```

  Once the debugging session is over, you can re-enable the reconciliation with

  ```
  flux resume kustomization <name>
  ```
