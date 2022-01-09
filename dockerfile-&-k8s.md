# **Dockerfile & k8s Manifests**

## **Dockerfile**

- **CMD**

  If we want to run a command on startup of a image, we can use CMD

  ```DockerFile
  CMD ["sleep", "5"]
  ```

  We can run this image like this -

  ```Bash
  docker run sleep-image
  ```

  **Problem: This is a static command. we can't change anything here.We can't change the sleep time.**

- **EntryPoint**

  If we want to use a command on startup with an argument given at runtime, we can use EntryPoint.

  ```DockerFile
  EntryPoint ["sleep"]
  ```

  We can run this image like this -

  ```Bash
  docker run sleep-image 10 -->  sleep 10
  docker run sleep-image --> error
  ```

  **Problem: Now, we can't run this image without giving a runtime sleep argument.**

- **EntryPoint & CMD**

  If we want to use a command on startup with an argument given at runtime (Also with a default value), we can use EntryPoint & CMD together.

  ```Dockerfile
  EntryPoint ["sleep"]
  CMD ["5"]
  ```

  Now, we can run this container like below -

  ```Bash
  docker run sleep-image 10 --> sleep 10
  docker rum sleep-image --> sleep 5 (Default value 5)
  ```

**Note :: For change the entrypoint of a container at runtime, we can specify the entrypoint while running the container like below -**

```Bash
docker run sleep-image --EntryPoint=NoSleep sleeper-image --> EntryPoint changed**
```

# **k8s manifest**

- **For providing runtime args such as a command or a value, we can use `args`.**

  e.g.

  Let's say, our Dockerfile looks like

  ```DockerFile
  EntryPoint ["sleep"]
  ```

  Then for provding the value as `10` for sleep command, we can use `args` like below -

  ```YAML
  apiVersion: v1
  kind: Pod
  metadata:
    name: my-sleeping-pod
  spec:
    containers:
    - image: sleeping-image
      name: sleeping-container
      args: ["10"] ---> docker run sleeper-image 10
  ```

- **For Changing the entrypoint itself, we can use `command` -**

  e.g.

  Let's say, our Dockerfile looks like

  ```DockerFile
  EntryPoint ["sleep"]
  ```

  Then for changing the entrypoint as `NoSleep` instead of sleep command, we can use `command` like below -

  ```YAML
  apiVersion: v1
  kind: Pod
  metadata:
    name: pods
  spec:
    container:
    - image: sleeper-image
      name: sleeper
      args: ["10"] ---> docker run sleeper-image 10
      command: ["NoSleep"] --> docker run --entrypoint=NoSleep sleeper-image
  ```
