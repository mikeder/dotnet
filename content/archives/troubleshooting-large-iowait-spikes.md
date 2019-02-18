---
title: Troubleshooting large IOWait spikes
date: 2016-09-25 21:58:45
categories: ["Archive"]
---

[1]: http://serverfault.com/questions/12679/can-anyone-explain-precisely-what-iowait-is

[2]: http://serverfault.com/questions/573396/centos6-and-long-wait-io-time-on-jbd2-dm-0-8

[3]: http://serverfault.com/questions/363355/io-wait-causing-so-much-slowdown-ext4-jdb2-at-99-io-during-mysql-commit

[4]: https://wiki.debian.org/fstab

[5]: https://forum.proxmox.com/threads/pveperf-very-bad-fsyncs-second.17249/

changed mount options:

- Before: defaults,noatime,nodiratime,barrier=1,data=ordered,errors=remount-ro
- After: relatime,barrier=0,errors=remount-ro

pveperf before:
```
root@pve-01:~# pveperf /
CPU BOGOMIPS:      19244.00
REGEX/SECOND:      959888
HD SIZE:           27.19 GB (/dev/dm-0)
BUFFERED READS:    195.02 MB/sec
AVERAGE SEEK TIME: 0.26 ms
FSYNCS/SECOND:     301.31
DNS EXT:           93.93 ms
DNS INT:           93.76 ms (sqweeb.net)

root@pve-01:~# pveperf /var/lib/vz
CPU BOGOMIPS:      19244.00
REGEX/SECOND:      978722
HD SIZE:           178.85 GB (/dev/mapper/pve-data)
BUFFERED READS:    197.73 MB/sec
AVERAGE SEEK TIME: 0.20 ms
FSYNCS/SECOND:     316.08
DNS EXT:           84.80 ms
DNS INT:           107.74 ms (sqweeb.net)

```

pveperf after:
```
root@pve-01:~# pveperf /
CPU BOGOMIPS:      19244.08
REGEX/SECOND:      953290
HD SIZE:           27.19 GB (/dev/dm-0)
BUFFERED READS:    176.81 MB/sec
AVERAGE SEEK TIME: 0.26 ms
FSYNCS/SECOND:     2128.05
DNS EXT:           113.88 ms
DNS INT:           106.68 ms (sqweeb.net)

root@pve-01:~# pveperf /var/lib/vz
CPU BOGOMIPS:      19244.08
REGEX/SECOND:      980483
HD SIZE:           178.85 GB (/dev/mapper/pve-data)
BUFFERED READS:    194.57 MB/sec
AVERAGE SEEK TIME: 0.20 ms
FSYNCS/SECOND:     2376.09
DNS EXT:           104.70 ms
DNS INT:           90.75 ms (sqweeb.net)
```

I also found there were some rouge monitoring processes running after a host reboot, collectd, splunkd, and filebeat were all running from previous installs. I hunted down and removed/stopped/deleted all associated files I could find on the host and the containers.

```
find / -name 'splunk'
find / -name 'collectd'
find/ -name 'filebeat'
```

After these changes I found that the IOWait spikes were still occurring at ~15-20min intervals. Doing some more digging I found something interesting, it seems that the /dev/sda device is the source of delay, and when checking smartctl I found that the firmware is different on this drive compared to a drive of the same model:

#### /dev/sda
```
root@pve-01:~# smartctl -a /dev/sda
smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.2.6-1-pve] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     SanDisk SDSSDA120G
Serial Number:    154414402842
LU WWN Device Id: 5 001b44 eff65c91a
Firmware Version: Z22000RL
User Capacity:    120,034,123,776 bytes [120 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Form Factor:      1.8 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2 T13/2015-D revision 3
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Aug 31 10:17:57 2016 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
```

#### /dev/sdc
```
root@pve-01:~# smartctl -a /dev/sdc
smartctl 6.4 2014-10-07 r4002 [x86_64-linux-4.2.6-1-pve] (local build)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     SanDisk SDSSDA120G
Serial Number:    154400408149
LU WWN Device Id: 5 001b44 efe903e55
Firmware Version: U21010RL
User Capacity:    120,034,123,776 bytes [120 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    Solid State Device
Form Factor:      2.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2 T13/2015-D revision 3
SATA Version is:  SATA 3.2, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Aug 31 10:22:50 2016 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
```

At this time it isn't clear if it is even possible to update or change the firmware on these drives..

Also look into further fstab tweaks:
http://www.howtogeek.com/62761/how-to-tweak-your-ssd-in-ubuntu-for-better-performance/

# Update 9/1/16 - 10:35AM

After looking back over the above documents, mount option tweaks for SSD's and such I realized I was overlooking one important task; fstrim. Most posts discussed enabling the discard mount option for SSD's but then other posts suggested this option causes a huge decrease in performance and to instead create a cron job that runs fstrim daily or weekly. I enabled a daily TRIM using the following script:

```
/etc/cron.daily/fstrim

#!/bin/sh

PATH=/bin:/sbin:/usr/bin:/usr/sbin

ionice -n 7 fstrim -v /
ionice -n 7 fstrim -v /var/lib/vz

```

I then manually ran the two commands to apply the trim job now and there was an immediate improvement. I am no longer seeing 15-20% spikes in IOWAIT every 20-30 minutes!!