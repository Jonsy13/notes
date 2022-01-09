# Imperative Commands

- Creating a pod template -

```
kubectl run <pod_name> --image=<image_name> --dry-run=client -o yaml > pod.yaml
```

- Checking previous logs of a crashing pod -

```
kubectl logs --previous <pod_name>
```

- Creating a Deployment -

```
kubectl create deploy <deployment_name> --replicas=2
```

- Creating a Replicaset -

- Creating a CM -

- Creating a secret -

- Creating a replicaset -

- Creating a replic.....

- Creating a service -
