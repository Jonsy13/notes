# Container Networking Interface (CNI) -

CNI specifies some rules which network plugins & Container runtimes should follow for integrating with container orchestrating vendors(k8s).

- **Rules for a Container runtime - (Docker, mesos, containerd, etc)**

  - Must create namespace
  - Identify network, to which container should be attached to
  - It should invoke network plugins when a container is added
  - It should invoke network plugins when a container is deleted
  - should provide json format of networks

- **Rules for network plugins - (flannel, calico, etc)**

  - Must support CMD line arguments like ADD, DEL, CHECK
  - Must support parameters like containerid, network ns etc
  - Must manage IPs for pods
  - Must return results in proper format.
