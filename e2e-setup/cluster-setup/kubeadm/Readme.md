# **Kubernetes Cluster Using Kubeadm**

> We should have provisioned VMs in AWS/GKE/AKS/Vagrant or any cloud providers.

Following script can be used to setup Container Runtime:

```BASH
wget https://raw.githubusercontent.com/jonsy13/notes/master/e2e-setup/cluster-setup/kubeadm/setup-runtime.sh
chmod +x setup-runtime.sh
./setup-runtime.sh
```

OR

```BASH
bash <(curl -s  https://raw.githubusercontent.com/jonsy13/notes/master/e2e-setup/cluster-setup/kubeadm/setup-runtime.sh)
```

- **As a requirement for our Linux Node's iptables to correctly see bridged traffic, you should ensure net.bridge.bridge-nf-call-iptables is set to 1 in your sysctl config, e.g.**

  ```BASH
  cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
  br_netfilter
  EOF

  cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
  net.bridge.bridge-nf-call-ip6tables = 1
  net.bridge.bridge-nf-call-iptables = 1
  EOF

  sudo sysctl --system
  ```

- **Then we need to have container-runtime setup on our VMs**

  - Update the apt package index and install packages to allow apt to use a repository over HTTPS:

    ```BASH
    sudo apt-get update

    sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    ```

  - Add Docker’s official GPG key:

    ```BASH
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    ```

  - Use the following command to set up the stable repository:

    ```BASH
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    ```

  - Install Docker Engine

    ```BASH
    sudo apt-get update

    sudo apt-get install docker-ce docker-ce-cli containerd.io
    ```

  - Configure Docker daemon

    ```BASH
    sudo mkdir /etc/docker

    cat <<EOF | sudo tee /etc/docker/daemon.json
    {
        "exec-opts": ["native.cgroupdriver=systemd"],
        "log-driver": "json-file",
        "log-opts": {
        "max-size": "100m"
        },
        "storage-driver": "overlay2"
    }
    EOF
    ```

  - Restart Docker and enable on boot:

    ```BASH
    sudo systemctl enable docker

    sudo systemctl daemon-reload

    sudo systemctl restart docker
    ```

- **Install kubeadm, kubelet & kubectl**

  - Update the apt package index and install packages needed to use the Kubernetes apt repository:

    ```BASH
    sudo apt-get update

    sudo apt-get install -y apt-transport-https ca-certificates curl
    ```

  - Download the Google Cloud public signing key:

    ```BASH
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    ```

  - Add the Kubernetes apt repository:

    ```BASH
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    ```

  - Update apt package index, install kubelet, kubeadm and kubectl, and pin their version:

    ```BASH
    sudo apt-get update

    sudo apt-get install -y kubelet kubeadm kubectl

    sudo apt-mark hold kubelet kubeadm kubectl
    ```

- **kubeadm cluster setup**

  For creating cluster using kubeadm, we have to be a root user, we can become root user as -

  ```BASH
  sudo -i
  ```

  ```BASH
  kubeadm init
  ```

  The output will look like -

  ```BASH
  Your Kubernetes control-plane has initialized successfully!

  To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

  You should now deploy a Pod network to the cluster.
  Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  /docs/concepts/cluster-administration/addons/

  You can now join any number of machines by running the following on each node
  as root:

  kubeadm join <control-plane-host>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>
  ```

  The token will be expired after 24 hrs, It can be regenerated using below command -

  ```BASH
  kubeadm token create --print-join-command
  ```

  Now, we can check the nodes,

  ```BASH
  ubuntu@ip-172-31-36-211:~$ kubectl get nodes
  NAME               STATUS     ROLES                  AGE   VERSION
  ip-172-31-36-211   NotReady   control-plane,master   34m   v1.23.1
  ```

  The nodes will be in `NotReady` state, as we haven't yet installed a cluster networking solution.

  ```BASH
  kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
  ```

  Wait for sometime, The nodes will come in `Ready` state.

  ```BASH
  ubuntu@ip-172-31-36-211:~$ kubectl get nodes
  NAME               STATUS   ROLES                  AGE   VERSION
  ip-172-31-36-211   Ready    control-plane,master   42m   v1.23.1
  ```

- **Control plane node isolation :**

  By default, your cluster will not schedule Pods on the control-plane node for security reasons. If you want to be able to schedule Pods on the control-plane node, for example for a single-machine Kubernetes cluster for development, run:

  ```BASH
  kubectl taint nodes --all node-role.kubernetes.io/master-
  ```

- **Joining your nodes :**

  The nodes are where your workloads (containers and Pods, etc) run. To add new nodes to your cluster do the following for each machine:

  - SSH to the machine

  - Become root (e.g. sudo su -)

  - Install docker runtime

  - Run the command that was output by kubeadm init. For example:

    ```BASH
    kubeadm join --token <token> <control-plane-host>:<control-plane-port> --discovery-token-ca-cert-hash sha256:<hash>
    ```

**NOTE :** If the instance you're using for kubeadm cluster is an EC2 instance then don't forget to open up the port 6443 in the master instance security group.
