# For creating a imagePullSecret - 

```BASH
    kubectl create secret docker-registry regcred \
    docker-server="" \
    docker-username="" \
    docker-password="" \
    docker-email=""
```

Here, the type of secret is `docker-registry`
      name of secret is `regcred`


Then, we can use this secret like - 

```YAML
spec:
    containers:
        - name: hii
          image: hii-image
    imagePullSecrets:
        - name: regcred
```