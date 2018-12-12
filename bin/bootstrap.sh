#!/bin/bash

# Vagrant/Ansible Bootstrap Script

echo "=== ANSIBLE ROLES"
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

echo "=== ANSIBLE EXECUTABLE"
./install_ansible
echo "DONE."

