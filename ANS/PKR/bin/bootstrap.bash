#!/usr/bin/env bash

# Vagrant/Ansible Bootstrap Script

# This bootstrap script:
# 1) gets the `ansible` roles onto the target machine
# 2) writes the ANSIBLE directory to the `/vagrant` fireshare directory
# 3) installs ansible onto the target machine

# The script is meant to be run by the Vagrant shell-provisioner.
#
# source <(curl -sL <SCRIPT URL>)
# 

echo "=== INSTALL ANSIBLE EXECUTABLE"
cd /x-ansible/ANS_PKR/bin
./install_ansible

