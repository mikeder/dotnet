---
title: Adding storage to prox-ve01
date: 2015-05-09 06:05:02
updated: 2015-05-09 02:23:52
categories: ["Archive"]
---

I initially installed 4 HDD's in the prox-ve01 server that were a mix of old hard drives from other computers that were still good but not being used.

* 250GB Seagate (Root filesystem "/")
* 300GB Seagate (Unmounted)
* 500GB WD (Unmounted - pulled from blackarmor "Downloads")
* 500GB WD (Unmounted - pulled from blackarmor "Storage")

I'm in the process of saving anything I may need off the 2 500GB drives and converting them to local storage for proxmox vm's and containers. As these drives were both in a Windows 7 machine in a prior life they need to be converted to linux partitions and filesystems from NTFS. This can be done via fdisk/cfdisk and mkfs commands.

<pre class="prettyprint">
# Delete partitions and create a new Linux partition
root@prox-ve01$ fdisk /dev/sdc
# Follow prompts to delete old partitions and create a new one of the Linux type.
# Make new file system of type ext4 on the new Linux partition with label "storage-1"
# -c Check the device for bad blocks before creating the file system.
# If this option is specified twice, then a slower read-write test is used instead of a fast read-only test.
root@prox-ve01$ mkfs.ext4 -c -c -L /storage-1 /dev/sdc1
</pre>