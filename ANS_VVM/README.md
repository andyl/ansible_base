# The ANS_VVM Directory

## About Vagrant 

Vagrant is an Infrastructure-As-Code tool for generating a virtual machine.
Vagrant is simple, works best on a single desktop using VirtualBox to build and
test.

We also use Packer to generate machine images.  Packer is more complicated, but
is well suited to generate machine images for cloud services like Proxmox, AWS
and Digital Ocean.

## The purpose of ANS_VVM 



Vagrant is simpler 

This directory is READ-ONLY, intended for use with Vagrant/Ansible
provisioning.

Working files are on the host at ~/VVM/<myimage>. 

The contents here will be over-written every time the Vagrant/Ansible
provisioner runs.

To customize the Vagrant/Ansible provisioning:

- copy this directory to an alternative directory (like `ansible`)
- update the `Vagrantfile` to point to the new directory
- edit the playbook and config file to your desires and re-run the provisioner

Note: on the guest, the host directory (with the `Vagrantfile` is mounted at
`/vagrant`)

