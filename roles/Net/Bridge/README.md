# Ansible Provisioning Notes for Linux Bridge

About: 

- This Role just writes a netplan config file to ~/.netconf/<host> 
- More details at ~/.netconf/README.md

Netplan: 

- Both Xubuntu and Ubuntu Server use 'netplan'
    * /etc/netplan/*
    * `sudo network apply`
- This works on both wifi-laptops (wlp_) and wired-desktops (enp_)

Network Renderer: 

- Ubuntu Desktops (like Xubuntu) use 'NetworkManager'.
- Ubuntu Servers use 'networkd'

Laptop WIFI: 

- Not all WIFI cards support bridged networking 
- Run `iw list` and look for "AP"
