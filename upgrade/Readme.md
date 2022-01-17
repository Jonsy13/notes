# Refer - https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/

- First, findout the version of latest patch available for kubeadm 

    ```BASH
    apt update
    apt-cache madison kubeadm
    ```
- Install latest patch of kubeadm

    ```BASH
    apt-mark unhold kubeadm && \
    apt-get update && apt-get install -y kubeadm=1.xx.x-00 && \
    apt-mark hold kubeadm
    ```

- Check if kubeadm bin is upgraded - 

    ```BASH
    kubeadm version
    ```

- Check latest version of controlplane components available - 

    ```BASH
    sudo kubeadm upgrade plan
    ```

- Check all details, we will have to upgrade `kubelet` manually. Upgrade the controlplane components - 

    ```BASH
    sudo kubeadm upgrade apply
    ```

- Now, before upgrading kubelet, we will have to drain our control plane node.

    ```BASH
    kubectl drain node <controlplane>
    ```

- Now, we have to install latest patch(Same as control plane components) available of kubelet & kubectl - 

    ```BASH
    apt-mark unhold kubelet kubectl && \
    apt-get update && apt-get install -y kubelet=1.xx.x-00 kubectl=1.xx.x-00 && \
    apt-mark hold kubelet kubectl
    ```

- Restart the kubelet & docker-daemon service - 

    ```BASH
    sudo systemctl daemon-reload
    sudo systemctl restart kubelet
    ```
- Now, uncordon control plane node - 

    ```BASH
    kubectl uncordon node <controlplane>
    ```

- Now we can follow same kubeadm bin upgrade process for other nodes

- For upgrading components on other node - 

    ```BASH
    sudo kubeadm upgrade node
    ```

- Now, same process can be followed for kubelet service as controlplane.