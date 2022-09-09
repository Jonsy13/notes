# **Kubernetes Cluster Using Kubeadm**

> We should have provisioned VMs in AWS/GKE/AKS/Vagrant or any cloud providers.

**The setup will look like below** - 

- LoadBalancer Node
- Master-1
- Master-2
- Master-3
- Worker-1
- Worker-2

**NOTE: All Nodes should be in same VPC**

## **Prerequisites -** 

- **Prerequisites for LoadBalancer Node -**

  We have to allow `6443` **TCP** port as inbound port in LoadBalancer Node for allowing connections for kube-api-server & loadbalancing the same to master nodes. 

- **Prerequisites for Master Nodes -**

  We have to allow a list of TCP & UDP ports as inbound ports in Master Nodes for allowing connections for all the control-plane components. 

- **Prerequisites for Worker Nodes -**

  We have to allow a list of TCP ports as inbound ports in Worker Nodes for allowing connections for all the worker plane components.

## Automated Nodes Setup

- **LoadBalancer Node Setup**

```BASH
  chmod +x setup-ha-proxy-node.sh
  ./setup-ha-proxy-node.sh
```

- **Worker/Master Nodes Setup**

```BASH
  chmod +x setup-node.sh
  ./setup-node.sh
```

## **Manual Setup (Skip to kubeadm setup if automation setup already done through scripts)**

* Login to the loadbalancer node 

* Switch as root - ` sudo -i` 

* Update your repository and your system 

```
sudo apt-get update && sudo apt-get upgrade -y

```

* Install haproxy

```
sudo apt-get install haproxy -y
```

* Edit haproxy configuration 

```
vi /etc/haproxy/haproxy.cfg
```

Add the below lines to create a frontend configuration for loadbalancer - 

```
frontend fe-apiserver
   bind 0.0.0.0:6443
   mode tcp
   option tcplog
   default_backend be-apiserver
```

Add the below lines to create a backend configuration for master1 and master2 nodes at port 6443. __**Note**__ : 6443 is the default port of **kube-apiserver**

```
backend be-apiserver
   mode tcp
   option tcplog
   option tcp-check
   balance roundrobin
   default-server inter 10s downinter 5s rise 2 fall 2 slowstart 60s maxconn 250 maxqueue 256 weight 100

       server master1 <PRIVATE_IP_OF_MASTER_1>:6443 check
       server master2 <PRIVATE_IP_OF_MASTER_2>:6443 check
```

Here - **master1** and **master2** are the names of the master nodes

* Restart and Verify haproxy

```
systemctl restart haproxy
systemctl status haproxy
```

Ensure haproxy is in running status. 

Run nc command as below - 

```
nc -v localhost 6443
Connection to localhost 6443 port [tcp/*] succeeded!
```

**Note** If you see failures for master1 and master2 connectivity, you can ignore them for time being as we have not yet installed anything on the servers. 

---

## Install kubeadm,kubelet and docker on master and worker nodes

In this step we will install kubelet and kubeadm on the below nodes 

* master1
* master2
* worker1
* worker2 

The below steps will be performed on all the below nodes. 

* Log in to all the 4 machines as described above

* Switch as root - `sudo -i` 

* Update the repositories 

```
apt-get update
```

* Turn off swap 

```
swapoff -a 
```

* Install kubeadm and kubelet

```
apt-get update && apt-get install -y apt-transport-https curl

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update

apt-get install -y kubelet kubeadm

apt-mark hold kubelet kubeadm 

```

* Install container runtime - **docker**

```
sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io -y
```

---

## Configure kubeadm to bootstrap the cluster 


We will start off by initializing only one master node. For this demo, we will use master1 to initialize our first control plane. 

* Log in to **master1** 
* Switch to root account - `sudo -i` 
* Execute the below command to initialize the cluster - 

```
kubeadm init --control-plane-endpoint "LOAD_BALANCER_DNS:LOAD_BALANCER_PORT" --upload-certs --pod-network-cidr=192.168.0.0/16 
```

Here, LOAD_BALANCER_DNS is the IP address or the dns name of the loadbalancer. I will use the dns name of the server, i.e. `loadbalancer` as the LOAD_BALANCER_DNS. In case your DNS name is not resolvable across your network, you can use the IP address for the same. 

The LOAD_BALANCER_PORT is the front end configuration port defined in HAPROXY configuration. For this demo, we have kept the port as **6443**. 

The command effectively becomes - 

```
kubeadm init --control-plane-endpoint "loadbalancer:6443" --upload-certs --pod-network-cidr=192.168.0.0/16 
```

Your output should look like below - 

```
To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of the control-plane node running the following command on each as root:

  kubeadm join loadbalancer:6443 --token cnslau.kd5fjt96jeuzymzb \
    --discovery-token-ca-cert-hash sha256:871ab3f050bc9790c977daee9e44cf52e15ee37ab9834567333b939458a5bfb5 \
    --control-plane --certificate-key 824d9a0e173a810416b4bca7038fb33b616108c17abcbc5eaef8651f11e3d146

Please note that the certificate-key gives access to cluster sensitive data, keep it secret!
As a safeguard, uploaded-certs will be deleted in two hours; If necessary, you can use 
"kubeadm init phase upload-certs --upload-certs" to reload certs afterward.

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join loadbalancer:6443 --token cnslau.kd5fjt96jeuzymzb \
    --discovery-token-ca-cert-hash sha256:871ab3f050bc9790c977daee9e44cf52e15ee37ab9834567333b939458a5bfb5 
```

The output consists of 3 major tasks - 

1. Setup kubeconfig using - 

```
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

```

2. Setup new control plane (master) using 

```
  kubeadm join loadbalancer:6443 --token cnslau.kd5fjt96jeuzymzb \
    --discovery-token-ca-cert-hash sha256:871ab3f050bc9790c977daee9e44cf52e15ee37ab9834567333b939458a5bfb5 \
    --control-plane --certificate-key 824d9a0e173a810416b4bca7038fb33b616108c17abcbc5eaef8651f11e3d146

```

3. Join worker node using 

```
kubeadm join loadbalancer:6443 --token cnslau.kd5fjt96jeuzymzb \
    --discovery-token-ca-cert-hash sha256:871ab3f050bc9790c977daee9e44cf52e15ee37ab9834567333b939458a5bfb5 
```

**NOTE** 

**Your output will be different than what is provided here. While performing the rest of the demo, ensure that you are executing the command provided by your output and dont copy and paste from here.**

Save the output in some secure file for future use. 

---

* Log in to master2 
* Switch to root - `sudo -i` 
* Check the command provided by the output of master1 

You can now use the below command to add another node to the control plane - 

```
kubeadm join loadbalancer:6443 --token cnslau.kd5fjt96jeuzymzb \
    --discovery-token-ca-cert-hash sha256:871ab3f050bc9790c977daee9e44cf52e15ee37ab9834567333b939458a5bfb5 \
    --control-plane --certificate-key 824d9a0e173a810416b4bca7038fb33b616108c17abcbc5eaef8651f11e3d146

```

* Execute the kubeadm join command for control plane on master2

![image](https://user-images.githubusercontent.com/44743158/68580399-4ce97900-049c-11ea-881b-a64728ed7b24.png)

Your output should look like - 

```
 This node has joined the cluster and a new control plane instance was created:

* Certificate signing request was sent to apiserver and approval was received.
* The Kubelet was informed of the new secure connection details.
* Control plane (master) label and taint were applied to the new node.
* The Kubernetes control plane instances scaled up.
* A new etcd member was added to the local/stacked etcd cluster.

```

Now that we have initialized both the masters - we can now work on bootstrapping the worker nodes. 

* Log in to **worker1** and **worker2**
* Switch to root on both the machines - ` sudo -i` 
* Check the output given by the init command on **master1** to join worker node - 

```
kubeadm join loadbalancer:6443 --token cnslau.kd5fjt96jeuzymzb \
    --discovery-token-ca-cert-hash sha256:871ab3f050bc9790c977daee9e44cf52e15ee37ab9834567333b939458a5bfb5 
```

* Execute the above command on both the nodes - 

* Your output should look like - 

```
This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

```

- **Control plane node isolation :**

  By default, your cluster will not schedule Pods on the control-plane node for security reasons. If you want to be able to schedule Pods on the control-plane node, for example for a single-machine Kubernetes cluster for development, run:

  ```BASH
  kubectl taint nodes --all node-role.kubernetes.io/master-
  ```

- **Deploy StorageClass :**

  ```BASH
  kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
  kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
  ```

**NOTE :** If the instance you're using for kubeadm cluster is an EC2 instance then don't forget to open up the port 6443 in the master instance security group.
