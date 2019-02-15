---
title: "UPS RPi IPMI"
date: 2015-01-09T08:00:04-05:00
categories: ["Archive"]
tags:
- linux
- virtualization
- dell
- sysadmin
- IPMI
- raspberrypi
---

# UPS -> RPi -> IPMI tool update

I realized this tool will not be able to run on the Raspberry Pi because the
linux package from CyberPower isn't available for ARM processors. I could
attempt to recompile it from the sources but I think I'd rather just write my
tool on the (x86) Ubuntu tools VM instead. I will probably just write an IPMI tool
that the pwrstat daemon can interface with when a shutdown is needed.
