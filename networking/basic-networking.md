# Networking basics

- All machines in same network are connected through switch.
- Two or more different networks are connected through a router
- For reaching a machine in a different network through router, we have to add GateWay in machines.

## Switch -

```
Machine-1 ----- Switch -------- Machine-2
```

## Router -

```
Machine-1 --- Network-1 ---- Router ----- Network-2 ---- Machine-2
                                |
                                |
                            Network-3
                                |
                            Machine-3
```

**Since switch is available in a single network, it is intelligent enough to forward packets from 1 machine to other machines in same network.**

**Since Router is connected between 2 or more different networks, we have add gateways for letting the router know, which gateway it has to use for reaching machines in other networks.**

**Some basic commands -**

- To check network interfaces on a host machine - `ip link` or `ifconfig`
- To check IPs assigned to a machine - `ip addr`
- To assign an IP to machine - `ip addr add`
- To add a GateWay to a machine for reaching to a machine in a different network connected to same router - `ip addr add <IP> via <GateWay>`
- To check routing table in a machine - `ip route` or `route`

**Notes:-**

By default a host machine can't forward packets to a different machine coming from a different machine. (For security purposes, it is disabled by default)
For enabling the same, we can do

```Bash
echo 1 > /proc/sys/net/ipv4/ip_forward
```

For checking, if packets forwarding is enabled, we can do

```
cat /proc/sys/net/ipv4/ip_forward`
```

if output is `1`, then it is enabled otherwise disabled.
