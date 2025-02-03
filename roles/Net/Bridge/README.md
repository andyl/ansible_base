# Ansible Provisioning Notes for Linux Bridge

## Network Types 

|         | 2204 | 2404 |
|---------|------|------|
| Desktop |      |      |
| Server  |      |      |

## Question 

Show how to configure a bridge on the incus host that allows:
- the LXC guests to get their address from LAN DHCP 
- easy SSH access between the host and guest

## Answer 

You can simply use the standard Linux bridge configuration - you don't need
OpenVSwitch! OpenVSwitch is generally used in more complex scenarios like data
centers or when you need advanced networking features.

For a typical home or small business setup, the standard Linux bridge (using
the `bridge-utils` tools like `brctl` or newer `ip` command) is perfectly fine
and actually simpler to set up. Here's what you need:

1. Create a bridge (these days, using the `ip` command is preferred):
   
```bash
ip link add name br0 type bridge
ip link set br0 up
```

2. Add your ethernet interface to it:

```bash
ip link set eth0 up
ip link set eth0 master br0
```

3. Configure your LXC container to use the bridge, in the container's config file:

```
lxc.net.0.type = veth
lxc.net.0.link = br0
lxc.net.0.flags = up
lxc.net.0.name = eth0
```

This gives you everything you need for containers to get IP addresses from your
router and be accessible on your LAN. OpenVSwitch would be overkill for this
basic setup.

There is no solution that will work for WIFI interfaces.

Here is a netplan file that sets up this configuration:

```
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: no
      dhcp6: no
  
  bridges:
    br0:
      interfaces: [eth0]
      dhcp4: yes
```
