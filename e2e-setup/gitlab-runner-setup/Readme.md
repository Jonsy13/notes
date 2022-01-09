# Gitlab Runner VM Setup on an EC2 Instance -

- Update and Upgrade the packages

```
sudo apt update && sudo apt upgrade -y
```

- Install dependencies for Docker

```
sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-releases
```

- Add GPG Key

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

- Add Repository for Docker

```
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

- Install docker

```
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

- Add Repository for Gitlab-Runner

```
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
```

- Install Gitlab-Runner

```
sudo -E apt-get install gitlab-runner

For an exact version,
sudo -E apt-get install gitlab-runner=1.13.7
```

- Register Gitlab-Runner

```
gitlab-runner register
systemctl restart gitlab-runner
```

- Give all permission to gitlab-runner user

```bash
visudo
gitlab-runner ALL=(ALL) NOPASSWD: ALL
```

- Checkout the `config.toml` file which is configuration file for GitLab runner

```bash
sudo su - gitlab-runner
sudo vi /etc/gitlab-runner/config.toml
```

Configuration file:

```yaml
concurrent = 1
check_interval = 0

[session_server]
session_timeout = 1800

[[runners]]
name = " "
url = " "
token = "XXXXXXXXXX"
executor = "kubernetes/Docker/DockerMachine"
[runners.custom_build_dir]
[runners.cache]
[runners.cache.s3]
[runners.cache.gcs]
[runners.cache.azure]
[runners.kubernetes]
host = ""
bearer_token_overwrite_allowed = false
image = "litmuschaos/litmus-e2e:ci"
```

Restart GitLab Runner

```bash
sudo systemctl restart gitlab-runner
sudo systemctl status gitlab-runner
```

## Uninstallation

```bash
sudo apt remove gitlab-runner
rm -rf /var/opt/gitlab
```
