# List of all docker images - 

```
chaosnative/hce-auth-server:2.8.0
chaosnative/hce-frontend:2.8.0
chaosnative/hce-license-module:2.8.0
chaosnative/hce-server:2.8.0
chaosnative/curl:2.8.0
chaosnative/mongo:4.2.8
chaosnative/argoexec:v3.2.3
chaosnative/chaos-exporter:2.8.0
chaosnative/chaos-operator:2.8.0
chaonative/chaos-runner:2.8.0
chaosnative/hce-event-tracker:2.8.0
chaosnative/hce-subscriber:2.8.0
chaosnative/workflow-controller:v3.2.3
chaosnative/go-runner:2.8.0
chaosnative/k8s:2.8.0
chaosnative/litmus-checker:2.8.0
```


The CLE Helm-chart is available here - https://github.com/chaosnative/cle-charts/tree/main/cle

---

# Steps for Installing ChaosNative Litmus Enterprise 

#### STEP - 1: Docker Images Setup

**Air Gapped Environment -**  Load all docker images into Nodes which are part of the cluster where we are installing CLE.

**Private docker image registry -** Retag & push all docker images to user’s docker registry & update the images in manifest/values.yaml as well before installing.

#### STEP - 2: CLE installation using Helm
1. Add the chaosnative helm repository

    ``` Bash
    helm repo add chaosnative https://charts.chaosnative.com
    ```

2. Create the litmus namespace

	```Bash
    kubectl create ns litmus
    ```

3. Install the CLE Helmchart along with modified values.yml for using images from custom image registry
    ```Bash
    helm install -n litmus --values values.yaml chaosnative chaosnative/cle --version 0.2.0
    ```

#### STEP - 3: Access the frontend using frontend service `chaosnative-cle-frontend-service`

By default, it will be available at NodePort service, so can be accessed using `http://<NODE_IP>:<NODE_PORT>` or can be patched to loadBalancer/Ingress as well.

#### STEP - 4: Login with admin credentials

>Username: admin
>Password: litmus

#### STEP - 5: Upload the trial licence provided through mail.
