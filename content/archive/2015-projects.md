---
title: "2015 Projects"
date: 2015-01-01T23:26:18-05:00
tags:
- archive
- 2015
- homelab
- poweredge
---

#### 2015 Projects

Getting in the first update of the New Year! I'm going to try and do an entry
to this log once a day for the rest of the year. That may be my only resolution
for now but I think logging and actively trying to work through a self
prescribed TODO list should keep me on track.

A few additions to the TODO list tonight, which I will probably tackle some of
tonight. The memory I put into TS2 is causing an amber lamp to flash on the
front of the server. This was half expected as I had the same issue with the
RAM when it was installed in TS1 but I couldn't remember which DIMM was
actually bad. So now that TS2 has been powered on for a few days it is
registering the same system event log which I can read with ipmitool.

```
61 | 12/29/2014 | 16:18:17 | Physical Security #0x52 | General Chassis intrusion | Asserted
62 | 12/29/2014 | 14:17:59 | Physical Security #0x52 | General Chassis intrusion | Deasserted
63 | 12/29/2014 | 14:29:00 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
64 | 12/29/2014 | 14:29:00 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
65 | 12/29/2014 | 14:29:00 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
66 | 12/29/2014 | 14:29:00 | Event Logging Disabled #0x06 | Correctable memory error logging disabled | Asserted
67 | 12/29/2014 | 15:33:23 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
68 | 12/29/2014 | 15:33:23 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
69 | 12/29/2014 | 15:33:23 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
6a | 12/29/2014 | 15:33:23 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
6b | 12/29/2014 | 15:33:23 | Event Logging Disabled #0x06 | Correctable memory error logging disabled | Asserted
6c | 12/29/2014 | 20:32:51 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
6d | 12/29/2014 | 20:47:07 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
6e | 12/29/2014 | 20:47:08 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
6f | 12/29/2014 | 20:47:08 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
70 | 12/29/2014 | 20:47:08 | Event Logging Disabled #0x06 | Correctable memory error logging disabled | Asserted
```

This log shows that I opened the case on 12/29/2014 to install the RAM and then
somehow went back in time. This may be due to the server not being powered on
for a couple months. It may also indicate that the CMOS battery on the
motherboard is dead and as a result the server looses track of time when it is
unplugged. Either way the log starts showing the same error I saw on TS1 before
I replaced all the RAM in there. I'll probably be ordering anothe 16GB kit for
TS2 just to have all new memory to work with until I retire these machines.

Since I've had IPMI on my mind the past couple of days I have realized my next
project. A python/flask web app to manage these servers via ipmitool is next on
'the list'. I got a CyberPower 1500VA UPS for these servers with some Christmas
money and it has a USB port for shutting down machines safely. I figure with
this port I should be able to interface with my own ipmitool wrapper and shut
the servers down safely if the power is out for longer than the battery can
keep everything running. Right now under standard(light) load the UPS can keep
everything running for ~12min. This should be more than enough time to safely
shut everything down if need be. I may come back and update this entry once
I've done some more research on how the UPS signals shutdown via the USB port.
Once finished the ipmitool wrapper program will live on my Raspberry Pi. I plan
to eventually have all of my python projects built into a nice Flask UI and
living on the RPi for easy access. Time to commit this entry before its
tomorrow.

####Update 00:12:

Adding link for CyberPower PowerPanel Linux Manual
+ http://www.cyberpowersystems.com/user-manuals/PPL-1.2_Software_UserManual.pdf
