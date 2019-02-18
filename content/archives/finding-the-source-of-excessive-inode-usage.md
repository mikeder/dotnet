---
title: Finding the source of excessive inode usage
date: 2016-11-23 10:10:57
categories: ["Archive"]
---

Determine if lack of disks space is an inode problem:
```
df -ih

Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/sda1       1000K  105K  896K   100% /
tmpfs            480K     8  480K    1% /dev/shm
```

Find folders with large number of inodes:
```
for i in /*; do echo $i; find $i |wc -l; done
```

Change to the directory with the highest number, in my case this morning it was /var.

Find specific folder w/ large number of inodes:
```
for i in ./*; do echo $i; find $i |wc -l; done
```

Change to the directory with the highest number again, in my case /var/spool.

Repeat.

I found that /var/spool/clientmqueue had 917,xxx tiny files in it (all likely undelivered mail), that once removed dropped the inode usage back down to 11%.
```
cd /var/spool/clientmqueue && find . -type f -delete
Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/sda1       1000K  105K  896K   11% /
tmpfs            480K     8  480K    1% /dev/shm
```

[http://stackoverflow.com/questions/653096/howto-free-inode-usage](http://stackoverflow.com/questions/653096/howto-free-inode-usage)