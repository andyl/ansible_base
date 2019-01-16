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

## Automation with Vagrant

These Ansible roles work with the [VVM (Vagrant Virtual
Machine)](https://github.com/andyl/VVM) repo for automated VM creation and
provisioning.

## Conventions

Playbooks define 1 `sys_user` (system user) and 1+ `gen_user` (generic user).

The sys_user and gen_user can be the same.  You can loop over gen_users.

Roles using a CamelCase name are designed to be called once for the `sys_user`.

Roles using a snake_case name are designed to be called once for each `gen_user`.

Everything is idempotent so if you re-run a role it's won't break.

## GenUser Loop Example Playbook 

Here's a playbook that loops over a collection of `gen_users`.

playbook.yml

      ---
      - hosts: all
        vars:
          - sys_user: vagrant
          - gen_users:
              - vagrant
              - user1
              - user2
          - lcl_user: "{{ lookup('env', 'USER') }}"
        remote_user:  "{{sys_user}}"
        become: true
        tasks:
          - name: sys_user config {{sys_user}}
            include: playbook_sys.yml 

          - name: gen_user config {{gen_user}}
            include: playbook_gen.yml 
            with_items: "{{gen_users}}"
            loop_control:
              loop_var: gen_user

playbook_sys.yml

      --- 
      - include_role: name=Vars/Predicates
      - include_role: name=Vars/Hostname
      - include_role: name=Vars/Predicates
      - include_role: name=Vars/Dump
      - include_role: name=Ruby/SysRuby     
      - include_role: name=CLI/Pkg         
      - include_role: name=CLI/Tzone       
      - include_role: name=CLI/Extras      
      - include_role: name=Lang/Pip         
      - include_role: name=Lang/Lua         
      - include_role: name=Lang/Nodejs      
      - include_role: name=Lang/Yarn        
      - include_role: name=Lang/erlang      
      - include_role: name=Lang/Elixir      
      - include_role: name=Lang/Elixir_ls   
      - include_role: name=Lang/Phoenix    
      - include_role: name=Edit/Tmux        
      - include_role: name=Edit/Vim         
      - include_role: name=Edit/Neovim      
      - include_role: name=Edit/Emacs       
      - include_role: name=DB/Sqlite        
      - include_role: name=DB/Influx        
      - include_role: name=DB/Postgres      
      - include_role: name=Svc/Grafana      
      - include_role: name=Virt/Docker      
      - include_role: name=Sys/Sftp

playbook_gen_yml

      --- 
      - include_role: name=User/setup
      - include_role: name=Ruby/chruby     
      - include_role: name=Ruby/install    
      - include_role: name=Ruby/gems       
      - include_role: name=CLI/util_base   

