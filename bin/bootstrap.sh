#!/bin/bash

# Vagrant/Ansible Bootstrap Script

# This bootstrap script does two things:
# 1) gets the `ansible` roles onto the target machine
# 2) installs ansible onto the target machine

# The script is meant to be run by the Vagrant shell-provisioner.
#
# source <(curl -s <SCRIPT URL>)
# 

echo "=== INSTALL ANSIBLE ROLES"
mkdir -p util
cd util
if [[ -d x-ansible ]] ; then
  echo "Updating roles"
  cd x-ansible
  git pull > /dev/null 2>&1
  cd ..
else
  echo "Cloning roles"
  sudo rm -rf x-ansible
  git clone https://github.com/andyl/x-ansible.git > /dev/null 2>&1
fi
cd x-ansible/bin

echo "=== INSTALL ANSIBLE EXECUTABLE"
./install_ansible
echo "DONE."

