# Container Storage Interface (CSI)

CSI is a general Interface exposed by kubernetes for providing support for all other Storage drivers.

Whenever a new storage driver is build, it has to follow CSI provided by kubernetes for working with the same.

CSI gives a number of RPC (Remote procedure calls) for communication between container orchestrator vendors & storage drivers. In our case, container orchestrator vendor is K8s.

**RPC -**

- createVolume
- deleteVolume
- controllerPublishVolume

**All storage drivers should implements these RPCs for working with k8s.**

Some scenarios -

- When a pod is created & a volume is requested for the same,
  k8s makes a RPC call(createVolume) to storage driver with required details. The storage driver should provision a volume accordingly & return details & statuscodes accordingly.

- When a pod is deleted & a volume is requested to be deleted for the same,
  k8s makes a RPC call(deleteVolume) to storage driver with required details. The storage driver should delete a volume accordingly & return details & statuscodes accordingly.
