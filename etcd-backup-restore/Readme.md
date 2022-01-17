# ETCD Backup & Restore

We can do backup of an ETCD DB using etcdctl command line utility - 

    ```BASH
    ETCDCTL_API=3 etcdctl snapshot save snapshot.db 
    ```

    Use the etcdctl snapshot save command. You will have to make use of additional flags to connect to the ETCD server.
    - --endpoints: Optional Flag, points to the address where ETCD is running (127.0.0.1:2379)
    - --cacert: Mandatory Flag (Absolute Path to the CA certificate file)
    - --cert: Mandatory Flag (Absolute Path to the Server certificate file)
    - --key:Mandatory Flag (Absolute Path to the Key file)

For restoring the ETCD DB,

- First, we need to stop kubea-api-server service

    ```BASH
    service kube-apiserver stop
    ```
- Then, we can use ETCDCTL to restore the DB - 

    ```BASH
    ETCDCTL_API=3 etcdctl snapshot restore snapshot.db --data-dir=/var/lib/backup-from-etcd 
    ```

- Change the configuration of etcd to use `/var/lib/backup-from-etcd` as `--data-dir`

- We can now restart the service daemon, etcd service & kube-apiserver service - 

    ```BASH
    systemctl daemon-reload
    service etcd restart
    service kube-apiserver start
    ```