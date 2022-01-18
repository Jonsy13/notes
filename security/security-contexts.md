# Security-Contexts 

We can provide security-contexts at pod-level as well as container-level.

- SC provided at pod-level are carried to all of it's containers.

    ```YAML
    spec:
    securityContext: 
        runAsuser: <user_id>
    ```
- SC provided at container-level overrides the SC at pod-level.

    ```YAML
    spec:
        containers:
            - name: <container_name>
              image: <image_name>
              securityContext:
                runAsUser: <user_id>
    ```

We can define capabilities only at container level.

```YAML
spec:
    conrtainers:
    - name: <container_name>
      image: <image_name>
      securityContext:
        capabilities:
            add: ["SYS_TIME", "NET_ADMIN"]
```