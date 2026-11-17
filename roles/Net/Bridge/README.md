# Ansible Provisioning Notes for Linux Bridge

Background: 

- We want a linux bridge on all Incus hosts, so that Incus clients can get their IP address from the network DHCP 
- We will migrate all incus servers to Xubuntu 26.04
- All laptops (lent, lake) run Xubuntu 26.04 
- There are still a couple of machines (especially ipro) running Ubuntu server 24.04 
- Going forward, we only care about incus servers and laptops running Xubuntu 26.04 

Scope: 

- The role only runs on physical Xubuntu 26.04 hosts; all other hosts are skipped
- Ansible reports Xubuntu as `ansible_distribution == 'Ubuntu'`, so Xubuntu is
  detected by the `xubuntu-default-settings` package
    * NB: the `is_xubuntu` predicate in Vars/Base is therefore always false
- `has_xfce` is not used - it only works while someone is logged into XFCE

About: 

- This Role just writes a netplan config file to ~/.netplan/<host>/99-bridge.yaml
- It does not touch /etc/netplan - apply it from the console with `~/.netplan/setup` then `~/.netplan/apply`
- More details at ~/.netplan/README.md

Interface selection: 

- `bridge_device` in host_vars overrides detection
- If the bridge is already applied, its wired member interface is reused
- Otherwise the interface holding the default route is used, if it's wired (`en*`, `eth*`)
- If the default route is on WiFi (or there is none), no bridge file is written
- The bridge reuses the NIC's MAC address, so DHCP leases/reservations stay the same

Netplan: 

- Xubuntu uses netplan as the config front-end, with NetworkManager as the renderer
    * /etc/netplan/*
    * `sudo netplan apply`
- Ubuntu Server uses netplan with the `networkd` renderer (not handled by this role)

Laptop WIFI: 

- WiFi interfaces can't be bridged in normal client (managed) mode
    * 802.11 only carries frames for the station's own MAC, unless both the card
      and the access point support 4-address (WDS) mode
    * NetworkManager refuses to add a client-mode WiFi device to a bridge
    * `iw list` showing "AP" means the card can act as an access point - that's not the same thing
- Laptops are bridged only when on wired ethernet (eg docked); WiFi-only laptops
  keep the default Incus NAT network (incusbr0)
