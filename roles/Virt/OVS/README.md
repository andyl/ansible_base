# Ansible Provisioning Notes

from Claude 2024 Sep 03 Tue - https://claude.ai/chat/9e258db3-0e2d-4095-be79-f4773dcaa59a 

## Question 

Will this configuration work for all network management software?  For example,
I have systems running Ubuntu 22.04 Server that use 'netplan', and Raspberry PI
systems that use 'iface-up/iface-down'.

## Answer 

You raise an excellent point. The configuration I provided earlier is indeed
not universal and would primarily work for systems that use the traditional
`/etc/network/interfaces` configuration method. For broader compatibility, we
need to account for different network management systems like Netplan (used in
Ubuntu 22.04) and the `if-up`/`if-down` scripts used in some Raspberry Pi
configurations. Let's address this:

```yaml
---
- name: Configure OVS Bridge with DHCP (Multi-platform)
  hosts: all
  become: yes
  vars:
    bridge_name: br0
    ethernet_interface: eth0

  tasks:
    - name: Install Open vSwitch
      package:
        name: openvswitch-switch
        state: present

    - name: Ensure OVS service is started and enabled
      systemd:
        name: openvswitch-switch
        state: started
        enabled: yes

    - name: Create OVS bridge
      openvswitch_bridge:
        bridge: "{{ bridge_name }}"
        state: present

    - name: Add ethernet interface to bridge
      openvswitch_port:
        bridge: "{{ bridge_name }}"
        port: "{{ ethernet_interface }}"
        state: present

    - name: Detect network management system
      command: which netplan
      register: netplan_check
      ignore_errors: yes
      changed_when: false

    - name: Configure networking based on system type
      block:
        - name: Configure for Netplan (Ubuntu 22.04+)
          template:
            src: netplan_config.yaml.j2
            dest: /etc/netplan/99-ovs-bridge.yaml
          when: netplan_check.rc == 0
          notify: Apply Netplan changes

        - name: Configure for traditional networking
          template:
            src: interfaces_config.j2
            dest: /etc/network/interfaces.d/ovs-bridge
          when: netplan_check.rc != 0
          notify: Restart networking

        - name: Configure for Raspberry Pi (if-up/if-down)
          template:
            src: rpi_interfaces.j2
            dest: /etc/network/interfaces
          when: 
            - netplan_check.rc != 0
            - ansible_facts['distribution'] == "Debian"
            - ansible_facts['architecture'] == "armv7l" or ansible_facts['architecture'] == "aarch64"
          notify: Restart networking

  handlers:
    - name: Apply Netplan changes
      command: netplan apply

    - name: Restart networking
      service:
        name: networking
        state: restarted

# Netplan configuration template (netplan_config.yaml.j2)
# network:
#   version: 2
#   renderer: networkd
#   ethernets:
#     {{ ethernet_interface }}:
#       dhcp4: no
#   bridges:
#     {{ bridge_name }}:
#       interfaces: [{{ ethernet_interface }}]
#       dhcp4: yes
#       openvswitch: {}

# Traditional networking template (interfaces_config.j2)
# auto {{ bridge_name }}
# allow-ovs {{ bridge_name }}
# iface {{ bridge_name }} inet dhcp
#     ovs_type OVSBridge
#     ovs_ports {{ ethernet_interface }}
# 
# auto {{ ethernet_interface }}
# allow-{{ bridge_name }} {{ ethernet_interface }}
# iface {{ ethernet_interface }} inet manual
#     ovs_bridge {{ bridge_name }}
#     ovs_type OVSPort

# Raspberry Pi networking template (rpi_interfaces.j2)
# auto lo
# iface lo inet loopback
# 
# auto {{ ethernet_interface }}
# allow-hotplug {{ ethernet_interface }}
# iface {{ ethernet_interface }} inet manual
# 
# auto {{ bridge_name }}
# allow-hotplug {{ bridge_name }}
# iface {{ bridge_name }} inet dhcp
#     bridge_ports {{ ethernet_interface }}
#     ovs_type OVSBridge

```

This updated playbook addresses the multi-platform issue by:

1. Detecting the network management system in use (Netplan or traditional).
2. Applying the appropriate configuration based on the detected system.
3. Including a specific configuration for Raspberry Pi systems.

Here's a breakdown of the changes:

1. **Netplan Configuration (Ubuntu 22.04+)**: 
   - Uses a YAML configuration that Netplan understands.
   - Configures the bridge and ethernet interface using Netplan's syntax.

2. **Traditional Networking Configuration**:
   - Similar to the previous version, uses `/etc/network/interfaces.d/` for
     configuration.
   - Suitable for systems still using the older networking setup.

3. **Raspberry Pi Configuration**:
   - Uses a specific template for Raspberry Pi systems.
   - Configures the bridge in the main `/etc/network/interfaces` file.
   - Uses `allow-hotplug` for better compatibility with Raspberry Pi hardware.

To use this playbook:

1. Save the main content as `configure_ovs_bridge_multiplatform.yml`
2. Create a `templates` directory in the same location as your playbook
3. In the `templates` directory, create:
   - `netplan_config.yaml.j2`
   - `interfaces_config.j2`
   - `rpi_interfaces.j2`
4. Fill each template file with the corresponding content from the comments in the artifact
5. Run the playbook:
   ```
   ansible-playbook configure_ovs_bridge_multiplatform.yml
   ```

This solution should work across different systems, including Ubuntu 22.04 with
Netplan, traditional networking systems, and Raspberry Pi configurations. The
playbook detects the system type and applies the appropriate configuration.

Remember to test this in a safe environment first, as network configurations
can potentially disrupt connectivity if not applied correctly.

