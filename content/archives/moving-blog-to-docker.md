---
title: Moving blog database
date: 2017-09-23 17:41:49
categories: ["Archive"]
---

Working on some of the initial steps to moving this blog to docker today. Since containers aren't exactly presistent I have to get the database migrated to a dedicated mysql node. Once that is done I can move the blog into a python2.7 container and onto a new docker host.

First I spun up a new Debian VM, as is tradition, and after updating and upgrading, I installed mysql-server 5.5.

```
root@mysql-01:~# apt-get update
root@mysql-01:~# apt-get upgrade
root@mysql-01:~# apt-get install mysql-server
root@mysql-01:~# mysql --version
mysql  Ver 14.14 Distrib 5.5.57, for debian-linux-gnu (x86_64) using readline 6.3
```

_In order to get the mysql server listening on all interfaces instead of just localhost, I had to comment out a single line in the config:_ `/etc/mysql/my.cnf`

  - comment out this line: `bind-address = 127.0.0.1` -> `#bind-address = 127.0.0.1`
  - and restart mysql server: `service mysql restart`

#### Before
```
root@mysql-01:~# netstat -tulpan
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
...
tcp        0      0 127.0.0.1:3306            0.0.0.0:*               LISTEN      10710/mysqld
...
```

#### After
```
root@mysql-01:~# netstat -tulpan
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
...
tcp        0      0 0.0.0.0:3306            0.0.0.0:*               LISTEN      10710/mysqld
...
```

I then ran some basic hardening steps like changing the root password, and disabling remote connections for root and anonymous users.

```
root@mysql-01:~# mysql_secure_installation
```

Created a new `blog` database and `bloguser` with the appropriate permissions:

```
root@mysql-01:~# mysql -u root -p
Enter password: supersecretpassw0rd
mysql> create database blog;
mysql> create user 'bloguser'@'localhost' identified by 'password';
mysql> grant all on testdb.* to 'bloguser' identified by 'password';
```

___

Then I just had to dump and import the existing database into the new one:

```
root@blog-01:~# mysqldump -u blog -p blog > blog.sql
root@blog-01:~# mysql -h mysql-01.sqweeb.net -u bloguser -p blog < blog.sql
```

Finally I modify `blog.py` to point at the new database and restart the blog python process. I could confirm the connection to the new database by checking the processlist:
```
mysql> show processlist;
+----+----------+--------------------+------+---------+------+-------+------------------+
| Id | User     | Host               | db   | Command | Time | State | Info             |
+----+----------+--------------------+------+---------+------+-------+------------------+
| 43 | bloguser | 192.168.2.48:41700 | blog | Sleep   |   22 |       | NULL             |
| 48 | root     | localhost          | NULL | Query   |    0 | NULL  | show processlist |
+----+----------+--------------------+------+---------+------+-------+------------------+
2 rows in set (0.00 sec)
```

Successful migration.