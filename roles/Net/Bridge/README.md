# Ansible Provisioning Notes for Linux Bridge

Background: 

- We want a linux bridge on all Incus hosts, so that Incus clients can get their IP address from the network DHCP 
- We will migrate all incus servers to Xubuntu 26.04
- All laptops (lent, lake) run Xbuntu 26.04 
- There are still a couple of machines (especially ipro) running Ubuntu server 24.04 
- Going forward, we only care about incus servers and laptops running Xbuntu 26.04 

About: 

- This Role just writes a netplan config file to ~/.netplan/<host> 
- More details at ~/.netplan/README.md

Netplan: 

- Xubuntu uses 'netplan'
    * /etc/netplan/*
    * `sudo network apply`
- This works on both wifi-laptops (wlp_) and wired-desktops (enp_)
- Ubuntu Desktops (like Xubuntu) use 'NetworkManager'.
- I think Xubuntu laptops also use 'NetworkManager' as the 'network renderer'

Laptop WIFI: 

- Not all WIFI cards support bridged networking 
- Run `iw list` and look for "AP"

CLAUDE: 
- please review the notes above and make corrections where needed 
- let me know if you have any questions about the intent 
- make sure that this only runs on Xubuntu 26.04 machines (desktops and laptops) 
- update tasks/main.yml to correctly configure the bridged network on Xubuntu 26.04 machines 
