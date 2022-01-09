# Storage Classes

## Static Provisioning :

In this case, we have to create a disk manually & then create a PV referencing that disk for storage.

## Dynamic Provisioning :

We use Storage classes for definig a dynamic provsioner, which can provision a Volume on demand & attach the same to pod whenever a claim is made.

```YAML
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
    name: my-sc
provisioner: <provsioner_name>
parameters:
    <specific_to_provisioner>
```

**Now, for using above storage class in a PVC, we can add storageClassName in pvc spec as below -**

```YAML
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: my-pvc
spec:
    storageClassName: my-sc
    accessModes:
        - ReadWriteOnce
    resources:
        requests:
            storage: 500Mi
```
