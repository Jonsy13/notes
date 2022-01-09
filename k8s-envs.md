# Environment Variables in Kubernetes -

There are many ways of providing env variables to resources.

- **Can be added to resources using `env` array inside the container.**

  ```YAML
  spec:
      containers:
      - image: my-sleeping-command
        name: sleeper
        env:
          - name: SLEEP_TIME
            value: "10"
  ```

- **Can be referenced from configMaps & Secrets**

  - **Using `envFrom`**:

    - Using ConfigMaps:

      ```YAML
      spec:
        containers:
        - image: my-sleeping-command
            name: sleeper
            envFrom:
            - configMapRef:
                name: CONFIG_MAP_NAME
      ```

    - Using Secrets:

      ```YAML
      spec:
        containers:
        - image: my-sleeping-command
            name: sleeper
            envFrom:
            - secretRef:
                name: SECRET_NAME
      ```

    **Note: This way all data from cm & secrets will be added to container**

  - **Using `valueFrom`**:

    - Using ConfigMaps:

      ```YAML
      env:
        - name: APP
          valueFrom:
            configMapKeyRef:
              - name: app-configMap
                key: APP --> Optional if same name as ENV
      ```

    - Using Secrets:

      ```YAML
        env:
        - name: APP
            valueFrom:
            SecretKeyRef:
                - name: app-secret
                key: APP --> Optional if same name as ENV
      ```

    **Note: This way, only referenced variables from secret/cm will be added to container**

- **Can be added by mounting the configMap in POD**

  ```YAML
  volume:
    name: app-configMap-volume
    configMap:
        name: app-configMap
  ```
