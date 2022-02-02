# Imperative Commands

- Command for checking details about a resource - 

    ```
    kubectl api-resources | grep "<resource_name>"
    ```

- **FQDN - <pod_name>.<namespace_name>.svc.cluster.local**

- Creating a pod with a port exposed - 

    ```
    kubectl run <pod_name> --image=<image_name> --port=<port>
    ```

- Creating a pod & exposing automatically as clusterIP service - 

    ```
    kubectl run <pod_name> --image=<image_name> --port=<port> --expose
    ```

- Listing pods with given labels - 

    ```
    kubectl get pods --selector <csv_of_labels>
    ```

- Creating a pod template -

    ```
    kubectl run <pod_name> --image=<image_name> --dry-run=client -o yaml > pod.yaml
    ```

- Checking previous logs of a crashing pod -

    ```
    kubectl logs --previous <pod_name>
    ```

- Creating a Deployment -

    using kubectl

    ```
    kubectl create deploy <deployment_name> --image=<image_name> --replicas=2
    ```

    or using manifest

    ```
    apiVersion: apps/v1
    kind: Deployment
    metadata:
        name: new-deploy
    spec:
        replicas: 2
        selectors:
            matchLabels:
            tier: nginx
        template:
            metadata:
            labels:
                tier: nginx
            spec:
                containers:
                - name: <container_name>
                    image: <image_name>
    ```

- Creating a Replicaset -

    using command:

    ```
    kubectl create rs <replicaset_name> --image=<image_name> --replicas=2
    ```

    Using manifest:

    ```
    apiVersion: apps/v1
    kind: ReplicaSet
    metadata:
        name: rs
    spec:
        replicas: 2
        selectors:
            matchLabels:
                tier: nginx
        template:
            metadata:
                labels:
                    tier: nginx
            spec:
                containers:
                - name: <container_name>
                image: <image_name>
    ```


- Creating a CM -

- Creating a secret -

- Creating a service -

- Tainting a node - 

    ```
    kubectl taint node <node01> <key><operator><value>:<Effect>
    ```

- Untainting a node - 

    ```
    kubectl taint node <node01> <key><operator><value>:<Effect>-
    ```

- Creating a DaemonSet - 

    - First, create a deployment manifest - 
        
        ```BASH
        kubectl create deploy <name> --image=<image> --dry-run=client -o -yaml > dep.yml
        ```
    - Now, change the kind from Deployment to DaemonSet & apply