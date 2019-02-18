---
title: More advanced database migration
date: 2018-08-29 01:49:38
updated: 2018-08-28 22:24:12
categories: ["Archive"]
---

This database migration or promotion allows for moving of data between two hosts in separate networks. We open an SSH tunnel from our local machine to a bastion or "jumpbox" within the same network of each database and then `mysqldump` the data from one host to another via local ports.


1. Setup `HISTCONTROL`

    <pre class="prettyprint">
        root@DESKTOP-VFK848F:~# export HISTCONTROL=ignorespace
        root@DESKTOP-VFK848F:~# # commands starting with a space will no longer show up in history
    </pre>

2. SSH Tunnel to both database hosts

    <pre class="prettyprint">
        # Setup local port forward to remote database 1
        root@DESKTOP-VFK848F:~# ssh -L localhost:localport:db_host_1:db_port_1 user@jumpbox
        root@DESKTOP-VFK848F:~# ssh -L localhost:3307:mysql-01.tsnet:3306 meder@pve-1.tsnet
        meder@pve-1:~$ # leave this window open
        # Setup local port forward to remote database 2
        root@DESKTOP-VFK848F:~# ssh -L localhost:3308:mysql-02.tsnet:3306 meder@pve-1.tsnet
        meder@pve-1:~$ # leave this window open
    </pre>

3. Dump from database 1 to 2

    <pre class="prettyprint">
        # The passwords have to be in line, so remember the extra space before the command to exclude it from history
        root@DESKTOP-VFK848F:~#  mysqldump --single-transaction -h 127.0.0.1 -P 3307 -u root -p'db1password' | mysql -h 127.0.0.1 -P 3308 -u root -p'db2password'         
    </pre>