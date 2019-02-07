---
title: "Proxmox Notes"
date: 2015-04-12T18:08:32-05:00
tags:
- archive
- homelab
- networking
- proxmox
---

#### Notes from Proxmox VE configurations

1. Do NOT hook up both NIC's to an unmanaged switch without first configuring
2. Configure the host eth0 w/o an assigned IP
3. Configure host vmbr0 with eth0 as a slave and DHCP can be used

```
# network interface settings
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet manual

iface eth1 inet manual

auto vmbr0
iface vmbr0 inet dhcp
	bridge_ports eth0
	bridge_stp off
	bridge_fd 0
```

* Cloning VM's while running works perfectly, that alone is worth any headache
experienced while installing Proxmox VE. I just made a clone of the cherrym-vm, logged in and could start the cherrymusic service in < 10 minutes.
