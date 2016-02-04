# x-ansible

Ansible Roles and Libraries

## Setup

1. Clone the repo

2. Edit your ~/.ansible.cfg

    - add `x-ansible` to your library path
    - set `x-ansible/roles` to your roles path

  eg

      
      # location of ansible library, eliminates need to specify --module-path
      library = /home/<username>/x-ansible:/usr/share/pyshared/ansible/modules/*
      # roles home directory
      roles_path = /home/<username>/x-ansible/roles

3. Profit
