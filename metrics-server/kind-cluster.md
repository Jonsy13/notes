# Metric Server on KIND Cluster -

- **Create a KIND Cluster**

  ```Bash
  kind create cluster --name <CLUSTER-NAME>
  ```

- **For monitoring setup, we will need a metrics-server, Which is not installed by default in KIND Cluster, so we need to install the same.**

  Either you can use this modified manifest from here
  https://gist.github.com/Jonsy13/f2d1c585ea32c8d23a5ddd2ebe5129ac

  OR, download the original components manifest artifact from Metrics-server release Page and modify the same.

  For KIND Cluster, we need to disable `TLS`.
  We can disable `TLS` by adding the following to the metrics-server container args in the downloaded manifest.

  ```Bash
  - --kubelet-insecure-tls #remove these for production: only used for kind
  ```

  Now, Apply the `components.yml` in your cluster

  ```Bash
  Kubectl apply -f components.yaml
  ```

  It will take some time for metrics server to get populated, User can check the behaviour using `top` command (`kubectl top command`)
  Once populated, we can see the output like below

  ```Bash
  ➜ ~ kubectl top nodes
  NAME                 CPU(cores) CPU% MEMORY(bytes) MEMORY%
  kind-control-plane   341m       8%   1203Mi        7%
  ```
