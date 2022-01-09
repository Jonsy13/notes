# Persistent Volume:-

For persisting data over the multinode cluster, Persistent volumes are used.

- **configuration for persisting data on host/nodes -**

  ```YAML
  apiVersion: v1
  kind: PersistentVolume
  metadata:
      name: my-persistent-volume
  spec:
      accessModes: - ReadOnlyMany
      capacity:
          storage: 1 Gi
      hostPath:
          path: /tmp/
          type: directory
  ```

- **Configuration for persisting data in AWS EBS -**

  ```YAML
  apiVersion: v1
  kind: PersistentVolume
  metadata:
      name: my-persistent-volume
  spec:
      accessModes: - ReadWriteOnce
      capacity:
          storage: 1 Gi
      awsElasticBlockStore:
          volumeID: <volumeID>
          fsType: ext4
  ```

> **Note -**
>
> - The accessModes can be - ReadOnlyMany, ReadWriteOnce, ReadWriteMany
> - There is 1-1 relationship between PVC & PV. If the all PVs are already bounded with a PVC, the a new PVC created will remain in pending state.

# PersistentVolumeClaims(PVC):

PVCs are used by a resource to claim a persistent volume according to parameters provided in PVC.

for e.g. For claiming a PV with 500Mi storage & ReadWriteOnce accessmode

```YAML
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: my-pvc
spec:
    accessModes:
        - ReadWriteOnce
    resources:
        requests:
            storage: 500Mi
```

This PVC will be bounded with PV, which matches the given config.

**We can also select a specific PV by providing selector in PVC**

```YAML
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: my-pvc
spec:
    selector:
        matchLabels:
            name: my-PersistentVolume
    accessModes:
        - ReadWriteOnce
    resources:
        requests:
            storage: 500Mi
```

**We can use above pvc in a pod like below**

```YAML
apiVersion: v1
kind: Pod
metadata:
    name: my-pod
spec:
    containers:
    - name: my-container
      image: images-name
      volumeMounts:
        - name: my-volume
          mountPath: /opt
    volume:
        - name: my-volume
          persistentVolumeClaim:
            claimName: my-pvc
```

> **Note:**
>
> When a pvc is deleted,
>
> - the PV is not deleted by default & will not be available again.
>   It depends on `persistentVolumeReclaimPolicy`, which is by default `Retain`
> - If it is set to `Delete`, then it will be deleted along with pvc.
> - It it is set to `Recycle`, then the data inside PV will be scrubed before making it available.

**Note: The pvc can't be deleted until the pod using the same is deleted.**
