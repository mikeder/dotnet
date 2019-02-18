---
title: Mounting Linux Raid Arrays At Boot
date: 2016-05-29 21:21:49
categories: ["Archive"]
---

I have been having issues on reboot ever since I put together this newest server. I have 2 new Linux raid arrays (/dev/md0 and /dev/md1) both in a raid 1 consisting of 2 disks each:

```
lsblk
NAME         MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
fd0            2:0    1     4K  0 disk
sda            8:0    0 111.8G  0 disk
├─sda1         8:1    0  1007K  0 part
├─sda2         8:2    0   127M  0 part
└─sda3         8:3    0 111.7G  0 part
  ├─pve-root 252:0    0  27.8G  0 lvm   /
  ├─pve-swap 252:1    0  13.9G  0 lvm   [SWAP]
  └─pve-data 252:2    0 181.8G  0 lvm   /var/lib/vz
sdb            8:16   0 931.5G  0 disk
└─md0          9:0    0 931.4G  0 raid1 /mnt/storage-black
sdc            8:32   0 111.8G  0 disk
└─sdc1         8:33   0 111.8G  0 part
  └─pve-data 252:2    0 181.8G  0 lvm   /var/lib/vz
sdd            8:48   0 931.5G  0 disk
└─md0          9:0    0 931.4G  0 raid1 /mnt/storage-black
sde            8:64   0   1.8T  0 disk
└─md1          9:1    0   1.8T  0 raid1 /mnt/storage-green
sdf            8:80   0   1.8T  0 disk
└─md1          9:1    0   1.8T  0 raid1 /mnt/storage-green
loop0          7:0    0    20G  0 loop
loop1          7:1    0     4G  0 loop
loop2          7:2    0     4G  0 loop
loop3          7:3    0     4G  0 loop
loop4          7:4    0     4G  0 loop
loop5          7:5    0     8G  0 loop
loop6          7:6    0     8G  0 loop
loop7          7:7    0     8G  0 loop
```

The problem was that when I would reboot the server, it would hang due to these arrays not being assembled prior to trying to mount them to their respective mount points. Also, during my investigation I discovered that the /etc/mdadm/mdadm.conf had duplicate array definitions in it for md0 and md1. So I removed all of the entries from mdadm.conf and rebuilt the arrays via webmin, now my config has the correct entries:

```
cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default (built-in), scan all partitions (/proc/partitions) and all
# containers for MD superblocks. alternatively, specify devices to scan, using
# wildcards if desired.
#DEVICE partitions containers

# auto-create devices with Debian standard permissions
CREATE owner=root group=disk mode=0660 auto=yes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
#ARRAY metadata=imsm UUID=2767c8b5:de4b04a1:5e951c51:ac28cfd4
#ARRAY /dev/md/Volume0 container=2767c8b5:de4b04a1:5e951c51:ac28cfd4 member=0 UUID=d7cb9f25:8059d13c:ca902df0:012c962c
#ARRAY metadata=imsm UUID=564868ed:b1bb3585:ad591521:e8e500a6
#ARRAY /dev/md/Volume1 container=564868ed:b1bb3585:ad591521:e8e500a6 member=0 UUID=84c88cc2:1d6bf1f8:9ea6f278:9921e1ed

# This configuration was auto-generated on Thu, 18 Feb 2016 07:05:06 -0500 by mkconf
ARRAY /dev/md0 uuid=4de7ae0b:483bdcba:2f8245fa:1c547394
ARRAY /dev/md1 uuid=fdb60bc0:e02c229d:0552aef6:90726bcd
```

Now that I've got my array definitions in order I went about mounting the arrays to their correct mount points and confirmed /etc/fstab:

```
cat /etc/fstab
# <file system> <mount point> <type> <options> <dump> <pass>
/dev/pve/root / ext4 errors=remount-ro 0 1
/dev/pve/data /var/lib/vz ext4 defaults 0 1
/dev/pve/swap none swap sw 0 0
proc /proc proc defaults 0 0
/dev/md0        /mnt/storage-black      ext4    defaults        0       0
/dev/md1        /mnt/storage-green      ext4    defaults        0       0
```

Once the configs are both in place and I can navigate through the file systems as expected I performed the following to set the disks to start at boot:

```
dpkg-reconfigure mdadm    # Choose "all" disks to start at boot
update-initramfs -u       # Updates the existing initramfs
```

[http://unix.stackexchange.com/questions/210416/new-raid-array-will-not-auto-assemble-leads-to-boot-problems](http://unix.stackexchange.com/questions/210416/new-raid-array-will-not-auto-assemble-leads-to-boot-problems)