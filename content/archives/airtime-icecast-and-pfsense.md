---
title: Airtime, Icecast and pfSense
date: 2015-05-15 03:54:57
categories: ["Archive"]
---

Taking another look streaming internet radio along with more robust firewall and DNS control. I found a real nice Open Source radio backend called <a href="https://www.sourcefabric.org/en/airtime/" target="_blank">Airtime</a> that re-kindled the idea of running an internet radio stream. Getting Airtime installed took a few tries, eventually I decided to just use their easy-install script. One thing to note is that the server locale needs to be set to US-UTF8 before postgresql is installed, otherwise the airtime installer will complain that the database was made with the wrong format and will error out.

```
airtime$ dpkg-reconfigure locales
# select en_US-UTF8
```

The Airtime <a href="http://sourcefabric.booktype.pro/airtime-25-for-broadcasters/easy-setup/" target="_blank">installation</a> took care of the Icecast server installation and configuration, once everything was up and running I converted it to a "production" setup:

```
# To convert a test installation into a production installation, you can run the command:
sudo dpkg-reconfigure airtime
# The dkpg-reconfigure command will run through the configuration steps shown in the Automated installation chapter, so that you can set the correct hostnames and passwords for # # your production Airtime server.
```

Once Airtime was installed I set about trying pfSense again. I wanted to figure out a way to route subdomains to the proper VM containers through a pfSense router/firewall. I also had to modify my network configuration a bit to separate the LAN in my house from the VM lan. To do this I created 3 bridges in Proxmox:

* vmbr0 - bound to port eth0, used for management (proxmox 192.168.1.2, pfSense 192.168.1.10)
* vmbr1 - bound to port eth1, used for pfSense WAN interface (192.168.1.12)
* vmbr2 - no port bound, used for VM network (all containers are assigned an interface on this bridge)

After connecting the bridges and interfaces I set the pfSense WAN in the DMZ of my ASUS router, everything is forwarded to the firewall and handled with WAN rules.

Since pfSense runs on Freebsd I had to set it up in a KVM virtual machine instead of an OpenVZ container. Once installed I found that the Squid3 package could be configured to work as a reverse proxy, which would give me the subdomain mapping that I was looking for. After installing the Squid3 package I setup the web servers and mappings to point to the appropriate VM's, I also set up aliases for these VM's so I don't have to remember the IP for them as they now get DHCP from the VMLAN interface in pfSense.

Once the mappings were in place I set a few firewall rules so that HTTP and HTTPS requests were allowed to pass to the reverse proxy roughly following <a href="https://forum.pfsense.org/index.php?topic=56318.0">this tutorial.</a> I still need to do some work on refining and cleaning up how these requests are handled because as it stands now all HTTP requests are forwarded to the blog server and all HTTPS requests are forwarded to the Airtime administration page, unless a specific port is defined. Not sure why this is happening because I defined specific endpoints to be available for the reverse proxy but oh well, its a start, for now I can access everything I need.