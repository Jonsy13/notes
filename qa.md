How to rollout update
How to record an upgrade


# Create a static pod on a node - 

Ps aux | grep config.yaml ==>>  /var/lib/kubelet/config.yaml ==>>  cat /var/lib/kubelet/config.yaml | grep "staticPodPath"

Cd /etc/kubernetes/manifests/

# Create a pod with ready-only secret mounted as volume - 

```YAML
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: mypod
    image: redis
    volumeMounts:
    - name: foo
      mountPath: "/etc/foo"
      readOnly: true
  volumes:
  - name: foo
    secret:
      secretName: mysecret
```

# List the static pods - 

- Static pods are created by kubelet of nodes on that nodes only. The pods are suffixed by hyphen & nodename. `-nodename`

# Using a different scheduler for scheduling a pod

  ```YAML
  spec:
    schedulerName: <scheduler_name>
  ```
# Learn about CertificatesSinging ----- 