# DNS Server:-

- We can reach a server from our machine in same network using it's IP. But if we want to reach it through it's name, we can add the same in `/etc/hosts` file.

  for e.g. for reaching an IP `192.178.2.0` as `DB` from our machine, we can add this as entry in /etc/hosts file.

  ```
  192.178.2.0 DB
  ```

- If we go with the above approach, the for reaching DB from many other machines, we will have to add the same entry in all the machines. Instead of doing this,
  we can make one server as Domain resolution server & add all IPs with names there. Then we can specify that server as nameserver in `/etc/resolv.conf` file in our hosts.

  In NameServer, `/etc/hosts/`

  ```
  192.178.2.0 DB
  ```

  In Host Machine, `/etc/resolv.conf`

  ```
  nameserver 192.178.2.8` => Here, 192.178.2.8 is IP of our nameserver
  ```

  Now, when we will try to access DB by name, it will look into `/etc/resolv.conf` file & then will try to resolve it from nameserver.

**Notes:**

- we can have the same entry in `/etc/hosts` file in host as well as in nameserver. The `/etc/hosts` file will take priority by default.
- For changing this default behaviour, we can edit our `/etc/nsswitch.conf` file.
  By default, the entry there is -

  ```
  hosts: files dns
  ```

  We can change it to -

  ```
  hosts: dns files
  ```

  Now, dns server will take priority.

- `8.8.8.8` is the default dns server by google, for public access, we can add this in our `/etc/resolv.conf`.

# Domain names

E.g. www.google.com.

- `.` is the root
- `.com` is the top level Domain
- `google` is Domain
- `www` is subdomain

Note, if we have a server at `my.domain.com`, Then outside world needs to access it through `my.domain.com`. But, as i'm inside the organization, i should be able to access it using just the subdomains.

For the same, we need to add `search` in `/etc/resolv.conf`

```
search domain.com
```

Now, if we try to do `ping my`, the it will try to reach `my.domain.com`.

# How do we store records in DNS server ?

**RECORD TYPES-**

```
IPv4 to name - A
IPv6 to name - AAAA
name to name - CNAME
```

**Some more important notes -**

- ping looks into /etc/hosts as well as /etc/resolv.conf
- nslookup only looks in /etc/resolv.conf
- dig

# How to configure a host as a DNS server ?

- First, We need to install DNS server on that host. we can download the binary & install.

- Next we need to add all IP to name pairs in `/etc/hosts` file on that host.
- Then, we have to tell DNS server to use the `/etc/hosts` file for fetching IP/Name combinations.
  By default, coreDNS server uses a `corefile` for this.
  We can edit the `corefile` & add this -
  ```
  {
    hosts /etc/hosts
  }
  ```
  Now, the coreDNS will use /etc/hosts for dns resolution

# Network namespaces

They are required to isolate the containers fron each other as well as host.

**Notes:**

- The container can't see the process running in host or any other container.

- Host can see all the process running on itself as well as in the containers.

**Some Basic commands**

- For creating a network namespace, we can do `ip netns add <network_namespace>`

- For checking network namespaces on the host, we can run `ip netns`

- For checking interfaces on a network namespace, we can do `ip netns exec <network_namespace> ip link` or `ip -n <network_namespace> link`

- For checking arp table on a network namespace, we can do `ip netns exec <network_namespace> arp`

- For checking routing table on a network_namespace, we can do `ip netns exec <network_namespace> route`

**Below notes are used for connecting 2 different network namespaces**

- For creating a virtual ethernet cable, we can do `ip link add <first_end_interface> type veth peer name <second_end_interface>`

- For attaching an end of veth to a network namespace, we can do `ip link set <first_end_interface> netns <first_end_network_namespace>`, Similarily for second.

- For assigning an IP to a network_namespace, `ip -n <network_namespace> addr add <IP> dev <network_interface>`

- For starting the communication in namespaces, we need to do `ip -n <network_namespace> set <interface_name> up`
