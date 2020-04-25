---
title: "Moving Docker Disk"
date: 2019-06-12T22:14:51-04:00
categories: ["Homelab"]
draft: true
tags:
  - new
  - docker
  - sysadmin
  - linux
---

My docker VM keeps running out of disk space, I set it up with a small 15G disk to start with and that isn't enough anymore.

Some excerpts pulled from [this](https://linuxconfig.org/how-to-move-docker-s-default-var-lib-docker-to-another-directory-on-ubuntu-debian-linux) site.

<!--more-->

Add new disk to VM through Proxmox UI
Hardware -> Add -> Disk -> SCSI (VirtIO) 200G

Add partition to the new disk `/dev/sdb` in my case.

```bash
root@docker-01:~# fdisk /dev/sdb

Command (m for help): p
Disk /dev/sdb: 200 GiB, 214748364800 bytes, 419430400 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x56122334

Device     Boot Start       End   Sectors  Size Id Type
/dev/sdb1          63 419430399 419430337  200G 83 Linux
```

Format the partition to EXT4

```bash
root@docker-01:~# mkfs.ext4 /dev/sdb1
```

Make a new directory and mount new disk to it:

```bash
root@docker-01:~# mkdir /mnt/docker
root@docker-01:~# mount /dev/sdb1 /mnt/docker
```

Add docker daemon config:

```bash
root@docker-01:~# vim /etc/docker/daemon.json

# Add contents
{
"graph":"/mnt/docker/docker"
}
```

Stop the docker daemon and move its files to the new path:

```bash
root@docker-01:~# systemctl stop docker
root@docker-01:~# rsync -aqxP /var/lib/docker/ /mnt/docker
```

Start docker daemon:

```bash
root@docker-01:~# systemctl start docker
```
