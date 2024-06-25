# The ANS_VVM Directory

## About Vagrant 

Vagrant is an Infrastructure-As-Code tool for generating a virtual machine.
Vagrant is simple, works best on a single desktop using VirtualBox to build and
test.

We also use Packer to generate machine images.  Packer is more complicated, but
is well suited to generate machine images for cloud services like Proxmox, AWS
and Digital Ocean.

Use Vagrant 

## About ANS_VVM 

This Vagrant tooling is organized under two directories:  

| Path                       | Purpose                                   |
|----------------------------|-------------------------------------------|
| `~/VVM`                    | Vagrantfiles to build virtual machines    |
| `~/util/x-ansible`         | ansible configuration playbooks and roles |
| `~/util/x-ansible/ANS_VVM` | configs for Vagrant auto-provision        |

The Vagrantfile mounts these directories:

| Guest Target     | Host Source         |
|------------------|---------------------|
| `/vvm/config`    | `~/VVM/<my_vm_dir>` |
| `/vvm/x-ansible` | `~/util/x-ansible`  |

Ansible playbooks and config scripts are located in `/vvm/x-ansible/ANS_VVM`

