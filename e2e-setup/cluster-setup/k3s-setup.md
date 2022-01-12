# Different K3s Setups -

- Without traefik enabled - (When using ingress-nginx)

  ```BASH
  curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--no-deploy traefik" sh -s - --write-kubeconfig-mode 644
  ```

- With Docker runtime

  ```BASH
  curl -sfL https://get.k3s.io | sh -s - --docker --write-kubeconfig-mode 664
  ```

**KUBECONFIG**

```BASH
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```
