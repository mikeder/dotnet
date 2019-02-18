---
title: Proxmox - Storage Gateway
date: 2018-10-18 22:50:01
categories: ["Archive"]
---

* Download AWS appliance .ova

* Unpack .ova:
```
meder@pve:~$ tar xvf AWS-Appliance-2018-09-26-1537973163.ova
AWS-Appliance-2018-09-26-1537973163.ovf
AWS-Appliance-2018-09-26-1537973163.mf
AWS-Appliance-2018-09-26-1537973163-disk1.vmdk
```

* Import .ovf:
```
root@pve:~# qm importovf 110 /home/meder/AWS-Appliance-2018-09-26-1537973163.ovf local-lvm
```

* Import VM image .vmdk:
```
root@pve:/# qm importdisk 110 /home/meder/AWS-Appliance-2018-09-26-1537973163-disk1.vmdk local-lvm
  Using default stripesize 64.00 KiB.
  Logical volume "vm-110-disk-1" created.
    (100.00/100%)
```

* Change disk1 driver to VirtIO
* Add additional VirtIO disk2 to allocate to cache.
* Add network adapter.
* Adjust memory to fit on your host, minimum recommended is 16GB.