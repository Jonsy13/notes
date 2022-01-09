# Ports For Different Componenets:

Ports Used by K8s components & which have to be openend on worker/master nodes.

```
kube-api-server --> 6443
ETCD-server --> 2379
kubelet --> 10250 (To be openend on all nodes)
kube-scheduler --> 10251
kube-controller-manager --> 10252
Services --> 30000-32767
```

**NOTE: If there are multiple master nodes, then 2380 for ETCD clients as well on all master nodes.**
