---
title: Customized Tornado Blog
date: 2015-05-03 10:54:19
updated: 2015-05-09 02:19:56
categories: ["Archive"]
---

This is a customized version of the Tornado blog example, customization includes:

* Bootswatch Cyborg theme
* Navbar
* /auth/create disabled after first user is created
* Day light savings handling
* More that I forgot..

Installing the blog:

<pre class="prettyprint">
$ apt-get install mysql-server python-dev libmysqlclient-dev libffi-dev git python-pip
$ pip install bcrypt mysql-python torndb tornado markdown futures
$ mkdir /opt/blog
$ cd /opt
$ git clone http://github.com/mikeder/blog
$ cd blog
$ mysql -u root -p
mysql> CREATE DATABASE blog;
mysql> GRANT ALL PRIVILEGES ON blog.* TO 'blog'@'localhost' IDENTIFIED BY 'blog';
mysql> quit
$ mysql --user=blog --password=blog --database=blog < schema.sql
$ python blog.py &
</pre>

Additionally I had to set the timezone:

<pre class="prettyprint">
$ dpkg-reconfigure tzdata
$ service mysqld restart
$ mysql -u root -p
mysql> SELECT @@session.time_zone; #should report SYSTEM
</pre>