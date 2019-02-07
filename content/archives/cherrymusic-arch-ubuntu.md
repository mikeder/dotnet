---
title: "Cherrymusic Arch Ubuntu"
date: 2014-12-18T11:06:35-05:00
tags:
- archive
- linux
- music
- development
---

#### CherryMusic update/migration from Arch Linux to Ubuntu 14.10

After struggling to get the the Arch installation of CherryMusic updated to the latest version I decided it would be easier to migrate back to Ubuntu.
Apparently I had originally installed CM via the Arch AUR and when the package
is actually installed versus just a repo clone it makes it more difficult to
update. Also it seems the 0.34.0 version had a bug that needed to get worked out anyway. So while I figuring out my next steps I waited for the 0.34.1 update to come out before finalizing. At least under Ubuntu/Debian I can run the server as a service like I'm used to doing.
Updating from now on should only require a git pull within the cherrymusic dir.
My steps taken for migration back to Ubuntu were as follows:

- Create new VM on esxi-ts1 host via VMWare vSphere Client
- Install Ubuntu Server 14.10 32bit/x86 on new VM
- Install OpenSSH and Samba(needed for connecting to NAS via cifs)
- Install cifs-utils

```
$ sudo apt-get install cifs-utils
```

- Edit /etc/fstab to mount music folder:

```
# Add this line to the bottom of the fstab file (//ts0 is my NAS)
//svault/Music /mnt/music cifs users,auto,credentials=/etc/.cifsauth 0 0
```

- Edit /etc/.cifsauth to include creds to connect to NAS

```
# Example /etc/.cifsauth - user with read-only access on NAS
username=cherry
password=music
```

- Make the /mnt/music folder and mount the NAS in it

```
$ sudo mkdir /mnt/music
$ sudo mount -a
```

- Install CherryMusic and dependencies
 * Roughly following this blog post: http://fomori.org/blog/?p=687

```
$ sudo apt-get install python3
$ sudo apt-get install mpg123 faad vorbis-tools flac imagemagick lame python3-unidecode
$ sudo apt-get install git
$ sudo adduser cherry
$ su cherry
$ git clone --branch devel git://github.com/devsnd/cherrymusic.git
# Create symlink to music folder for cherry's basedir
$ ln -s /mnt/music/\!SORTED/ /home/cherry/cherrymusic/basedir
# Start server with --setup tag and perfor initial configuration
$ python3 cherrymusic --setup
```

- Connect to localhost:8080 to configure (cherryM:8080 in my case)
- Kill server with ^C so it can be run as a service
- Init script pulled from:
 * https://github.com/Lord-Simon/Scripts/tree/master/cherrymusic
 * Edit /etc/init.d/cherrymusic to fit install

```
$DIR=/home/cherry/cherrymusic
...
USER=cherry
GROUP=cherry
```

- Once script is install start the server back up as a service

```
$ sudo service cherrymusic start
$ sudo service cherrymusic status
 * CherryMusic 'cherrymusic' is running (pid 5758).
```

- Update DHCP reservations and port forwarding to point to new server.
