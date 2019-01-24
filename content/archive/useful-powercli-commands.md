---
title: "Useful Powercli Commands"
date: 2015-02-12T08:26:08-05:00
tags:
- archive
- random
- notes
- cli
---

#### PowerCLI Useful command

Adding this to the list of useful commands for the sysadmin world

```
# IPAddress[0] = internal IP, IPAddress[2] = external IP
Get-VM "xb1-*lobby*" | Select Name, @{N="IP Address";E={@($_.guest.IPAddress[2])}}
```
