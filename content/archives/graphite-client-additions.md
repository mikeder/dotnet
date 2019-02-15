---
title: "Graphite Client Additions"
date: 2015-02-19T04:26:37-05:00
tags:
- archive
- homelab
- graphite
- metrics
- dashboards
---

# graphite-client additions

A couple of weeks ago I updated the monitoring of the VM's I run by installing
a [graphite](http://graphite.wikidot.com/) client on all of them that reports
cpu load averages back to the graphite VM. This basic client was based on an
example client found in the graphite documentation, that I modified a bit to
add daemonizing functionality. Now that its been running a little while I've
 realized I want to add some more functions or checks to it to generate some
  more useful metrics. Here is a high level overview of what I'll be adding:
  
- [ ] Collect host data on startup
  - [ ] hostname
  - [ ] number of CPU's
  - [ ] number of NIC's
  - [ ] listening ports
- [ ] Config file/JSON checks list (uncomment lines to run check)
- [ ] Area for custom checks to be added later

Right now I am using a library called [psutil][12] to grab active connections to
a specific port on one client. I plan to expand the psutil integration to
include all of the available functionality in the library that you can then add
and remove checks for by uncommenting lines in the config. This library requires
being built on the machine its being used on which requires that python-dev be
installed for compiling. If I find a method that doesn't require this I may
end up switching out psutil for another utility but I haven't found that method
yet.
