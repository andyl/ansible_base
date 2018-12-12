# The ANSIBLE Directory

This directory is READ-ONLY, intended for use with Vagrant/Ansible
provisioning.

The contents here will be over-written every time the Vagrant/Ansible
provisioner runs.

To customize the Vagrant/Ansible provisioning:

- copy this directory to an alternative directory (like `ansible`)
- update the `Vagrantfile` to point to the new directory
- edit the playbook and config file to your desires and re-run the provisioner

Note: on the guest, the host directory (with the `Vagrantfile` is mounted at
`/vagrant`)

