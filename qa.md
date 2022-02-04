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

# For checking default gateway - 

    ```BASH
    ip route show default
    ```

# Learn about netstat



# Learn about CertificatesSinging ----- 


Mock Exam - 2 

# Create a new user called john. Grant him access to the cluster. John should have permission to create, list, get, update and delete pods in the development namespace . The private key exists in the location: /root/CKA/john.key and csr at /root/CKA/john.csr.

# Create a nginx pod called nginx-resolver using image nginx, expose it internally with a service called nginx-resolver-service. Test that you are able to look up the service and pod names from within the cluster. Use the image: busybox:1.28 for dns lookup. Record results in /root/CKA/nginx.svc and /root/CKA/nginx.pod

Mock Exam - 3

