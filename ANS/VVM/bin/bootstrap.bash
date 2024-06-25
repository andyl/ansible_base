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

function writekey() {
  [[ $# == 1 ]] || return 0
  echo "=== WRITING KEY"
  echo $1 > /tmp/hostkey.pub
}

# echo "=== INSTALL ANSIBLE ROLES"
# mkdir -p util
# cd util
# if [[ -d x-ansible ]] ; then
#   echo "Updating roles"
#   cd x-ansible
#   sudo git pull > /dev/null 2>&1
#   cd ..
# else
#   echo "Cloning roles"
#   sudo rm -rf x-ansible
#   git clone --depth=1 https://github.com/andyl/x-ansible.git > /dev/null 2>&1
# fi

# to prevent copying the ANSIBLE directory, add
# `export NOANSIBLE=true` to your shell provisioner
# echo "=== COPY /vagrant/ANSIBLE"
# mkdir -p /vagrant
# rm -rf /vagrant/ANSIBLE
# [ -z $NOANSIBLE ] && cp -r x-ansible/ANSIBLE /vagrant

echo "=== INSTALL ANSIBLE EXECUTABLE"
cd /vvm/x-ansible/ANS/VVM/bin
./install_ansible

