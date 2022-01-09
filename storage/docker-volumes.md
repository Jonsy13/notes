**NOTE - All the docker resources related directory/files are created inside `/var/lib/docker`**

# **Docker Directory Structure**

Everything is stored as layers.

- Image layers are Read Only. ( As they are used by multiple containers )
- Container layers are Read/Write ( Every container is isolated from each other )

```
/var/lib/docker
|--aufs
|--volumes
|--images
|--containers
```

All above management is done by storage drivers - aufs, overlay, overlay2 & many others.

> **Note - aufs is default storage driver for ubuntu. Docker chooses suitable storage driver according to host.**

## **Volumes**

- For mounting a volume, (This will mount volumes inside /var/lib/docker/volumes)

  `docker run -v volume_name:<path_to_directory-inside-container-to-be-persisted> <image_name>`

- For mounting any other directory,

  `docker run -v <full_path_to_directory_on_host>:<path_to_directory-inside-container-to-be-persisted> <image_name>`

**Note: In both above cases, if volume doesn't exist, docker will be create it.**

## **Mounts**

For better understanding & distinguishing, we can use `--mount` when mounting a normal directory

`docker run --mount type=bind source=<full_path_to_directory_on_host>, target=<directory-inside-container-to-be-persisted> <image_name>`

**Note:**

- In this case, if the directory doesn't exist, it will give error.
- By default, `--mount` will create a Read/Write volume. If we want to create a Readonly volume, we can do that like below -

```
  docker run \
   --mount type=bind source=<full_path_to_directory_on_host>,target=<directory-inside-container-to-be-persisted>,readonly \
   <image_name>
```

More details on `type` is available [here](https://docs.docker.com/storage/bind-mounts/#choose-the--v-or---mount-flag)

## **Volume-drivers**

Volumes are managed by volume drivers.
There are many volume-driver plugins, which can be used for storing data on different types of storage providers or hosts from the containers.

By default, `local` is used by docker for mounting volumes data from containers onto host.
Other plugins can be used for storing data on other cloud providers.
for e.g. `rexpay/ebs` is used for storing data on `aws ebs`

```
    docker run \
    --volume-driver rexpay/ebs \
    --mount type=bind,source=<EBS_VOL>,target=<container_path> \
    <image_name>
```
