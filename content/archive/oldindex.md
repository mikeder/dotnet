## Mike Eder - think/work log

###Links:
* GitHub
 * [My Home][1]
* SqweebNet
 * [Home][2]
 * [CherryMusic][3]
 * [GitLab][4]

[1]: http://github.com/mikeder
[2]: http://sqweeb.net
[3]: http://cherry.sqweeb.net
[4]: http://git.sqweeb.net
[5]: https://cherrypy.readthedocs.org/en/latest/
[6]: http://www.makotemplates.org/
[7]: http://pygal.org/
[8]: http://overviewer.org
[9]: http://graphite.wikidot.com/
[10]: https://github.com/mikeder/graphite-client
[11]: http://graphite.wikidot.com/quickstart-guide
[12]: https://github.com/giampaolo/psutil
[13]: http://www.tornadoweb.org/en/stable/
[14]: http://docs.mongodb.org/manual/core/introduction/

### Todo:

- [ ] Write UPS -> IPMI tool interface
- [ ] Write CherryMusic DB connector/parser script
- [ ] Organize vinyl collection..


--------------------------------------------------------------------------------
### Thu Feb 19 08:14:56 EST 2015

#### Upping Graphite data retention

Lengthening the storage time for graphite metrics, default is 1 second
resolution for 1 day. The new schema will be as follows:

```
# /opt/graphite/conf/storage-schemas.conf

[sqweeb]
pattern = .*
retentions = 1s:1d,1m:7d,5m:30d
```

This will allow me to see more overall trending views on Grafana while still
keeping the tight 1 second resolution for checking out spikes.

#### 08:50 update

Two things were found out while making the storage-schema change above:

1. Just chaging storage-schema.conf and restarting carbon-cache.py is not
enough to get the changes in place. (further investigation required)

I suspected this may be a problem because the graphite docs did mention that
the whisper data files are preallocated, meaning that all the required data
points for the retention values are all written out in 0's so the files
don't explode later on as they are written to. This means that simply
changing the values in storage-schema.conf will not recreate the existing
whisper data files (/opt/graphite/storage/whisper/basename/metric.wsp) so
you can either use whisper-resize.py or resize each table or you can just
delete the data files as I did and when carbon-cache.py is restarted now it
will recreate the files in the correct size.

2. When graphite-client attempts to send an update and the receiver (graphite)
is not listening, graphite-client crashes. (will try:except this)

This is going to be part of the work to graphite-client additions that I do
this weekend. I am still chewing through my options for getting metrics from
the host machine, there are many different stats daemons available:
(statsd, collectd, Diamond, etc.)

--------------------------------------------------------------------------------
### Thu Feb 19 04:26:37 EST 2015

#### graphite-client additions

A couple of weeks ago I updated the monitoring of the VM's I run by installing
a [graphite][9] client on all of them that reports cpu load averages back to the
graphite VM. This basic client was based on an example client found in the
graphite documentation, that I modified a bit to add daemonizing functionality.
Now that its been running a little while I've realized I want to add some more
functions or checks to it to generate some more useful metrics. Here is a high
level overview of what I'll be adding:

1. Collect host data on startup
 * hostname
 * number of CPU's
 * number of NIC's
 * listening ports
2. Config file/JSON checks list (uncomment lines to run check)
3. Area for custom checks to be added later

Right now I am using a library called [psutil][12] to grab active connections to
a specific port on one client. I plan to expand the psutil integration to
include all of the available functionality in the library that you can then add
and remove checks for by uncommenting lines in the config. This library requires
being built on the machine its being used on which requires that python-dev be
installed for compiling. If I find a method that doesn't require this I may
end up switching out psutil for another utility but I haven't found that method
yet.

--------------------------------------------------------------------------------
### Thu Feb 12 08:26:08 EST 2015

#### PowerCLI Useful command

Adding this to the list of useful commands for the sysadmin world

```
# IPAddress[0] = internal IP, IPAddress[2] = external IP
Get-VM "xb1-*lobby*" | Select Name, @{N="IP Address";E={@($_.guest.IPAddress[2])}}
```

--------------------------------------------------------------------------------
### Thu Feb  5 08:41:03 EST 2015

#### SqweebNet + Graphite + Grafana

- [X] Update sqweeb.net

I spent most of the day yesterday setting up a few new things on the sqweeb.net
servers, specifically Graphite and Grafana. I started with a new Ubuntu VM,
updated it, install the short stack (open-vm-tools, vim, git, htop), install
the extend stack (python-pip, python-dev, build-essentials). I think I'd rather
continue this in a wordpress post, over at > http://sqweeb.net

--------------------------------------------------------------------------------
### Sun Feb  1 13:19:00 EST 2015

16410 items, totalling 126.6 GB

--------------------------------------------------------------------------------
### Sat Jan 31 00:11:38 EST 2015

- [X] Update /dht

Its been a while since an update, but there is no shortage of new stuff to talk
about just a shortage of time to come and write about it. I am slowly making
progress on my cherrypy-default repo, I have build a database search and parse
script to include. I also recoded my Arduino temperature sensor so that its
values are available via a simple JSON API, now my tools VM runs a script that
hits the IP of the sensor (192.168.1.20) collects the values, and inputs them
into a SQLite database. I can then use a custom script to grab the last 24hrs
worth of values out of that database and render a chart via PyGal. Its all
slowly coming together.

In addition to those things I have also been thinking over a blog post about
how much Linux kicks Windows ass. I recently switched my main pc over to
Xubuntu 14.10 and it has been great. The main reason I've been so pleased with
how Linux is working on my machine is because I have this Presonus Firestudio
Project, its a firewire audio interface, and I could not for the life of me get
it working properly on this machine while running Windows. I had resorted to
connecting it to an old laptop running Windows XP that I would then RDP into
when I wanted to use it to record some audio. Well since moving over to Linux I
decided I would give it another try. I did some Googling and found that I
should need 2 programs, FFADO and QJackCTL. I used the Ubuntu software center
to install these two programs. After an initial trial and error period of about
10 minutes I found that I needed to power cycle the audio interface and then
start up FFADO. FFADO immediatly recognized the interface! No crappy drivers
from Presonus needed, no fiddling around with IRQ's and all that bullshit, it
just found it right away. Now I start up QJackCTL, and per some instructions
found online I set it to use the firewire driver, set the sample rate and depth
and then click the start button to start the DBUS engine. The red status light
on the audio interface turns to blue indicating its active! I do some quick
recording tests at 24bit/96khz and the audio is clean, no pops, no crackling,
no bullshit. It finally works the way its supposed to, this is awesome! I just
about hugged my PC. I can't wait to start recording crappy electronic music
again!

--------------------------------------------------------------------------------
### Mon Jan 26 21:16:02 EST 2015

```
# Copy new render files over to web server.
minecraft@mc-mum:~$ cd renders
minecraft@mc-mum:~/renders$ scp * meder@web:/home/meder/minecraft


```

--------------------------------------------------------------------------------
### Sun Jan 25 02:55:21 EST 2015

#### sqweeb.net changes

Thinking through the changes I want to make to sqweeb.net, I may end up doing
away with wordpress completely as I don't really see myself updating an actual
blog very often. This log has sort of taken place of a regular outlet for
things I am working on. For now this update will be a sort of place holder for
the changes I want to make:

* Exchange LAMP stack for CherryPy
* CherryPy plugins to work on
  * Data collection (dht, rsdc, cherrymusic stats)
  * Data processing (SQLite search/parse)
  * Vinyl collection/rips logging
  * UPS status
  * IPMI status
  * Admin panel
* Minecraft server map

While a LAMP stack paired with Wordpress is a very common, stable and easily
themed setup its kind of boring. I want something more custom that I can easily
modify to suite my personal taste and needs, although this may open me up for
exploit if I'm not careful.

I still need to decide what is the best route to take to convert the dht sample
data into graphs. Currently the Arduino/sensor makes a call to a php page that
adds the values to a MySQL database. I think it would be better to just have
the Arduino serve a basic XML page that it can update at regular intervals and
then the data collection agent (RaspberryPi or Tools VM) can grab the values
from that sensor page and store them in a SQLite database. From there I will
process the data however necessary. I found a very nice looking python svg
plotting library called [pygal][7] which should serve my needs
very nicely. It has support for a wide variety of graphs and styles which
already fit the style I have in my head for the overall look of the new
'portal'.

As far as the vinyl collection/rips logging, this would just be a simple page
for entering catalog and matrix numbers as well as any info I may want to keep
track of if/when I rip the vinyl to a digital format. I may also want to add an
option for album art searching similar to what CherryMusic uses.

UPS and IPMI status checking just because, really my server setup is not
critical to know that status of 24/7. It certainly doesn't have a large user
base or anything (me) but I like the idea of monitoring, its what I do.

The Minecraft server map will most likely use [Overviewer][8] to generate a map
of the small server that my girlfriend and I play on. Pretty simple stuff to
implement, my front end would likely only need to schedule when to run the
overviewer.py script.

--------------------------------------------------------------------------------
### Sat Jan 24 09:44:56 EST 2015

#### RSDC v1.2

I have finished the SQLite3 integration into the RSDC script. For now it isn't
in plugin form because I wanted to just push to get it working. Now that I have
all of the originally intended functionality working I can work on breaking it
out to work with a cherrypy install. For now though I'm very pleased with how
well the script works. In addition to the script changes I found that pafy had
a few updates since I last installed it so I upgraded from v0.3.64 -> v0.3.68
which seems to have fixed a bug where YouTube would give a 403 Forbidden error
on certain videos.

--------------------------------------------------------------------------------
### Sat Jan 24 00:58:25 EST 2015

#### More RSDC tweaks and CherryPy thoughts

Not much going on at work tonight so to try and get back into the programming
mindset I'm making some tweaks to the RSDC script. I'm still toying around with
the idea of an overhaul i.e. version 2.0 that would include:

* Sqlite DB entries:
  * Link tracking
  * Download counts
  * Download sizes
* Breakout functions into class/plugins for handling Soundcloud and YouTube
* Better track processing/tagging
  * Remove extra space from after '-' seperator
* Download folder cleaning (inDir won't be needed if links are tracked)

Some more thoughts I had for the cherrypy-default repo I'm working on:

* Login function borrowed from CherryMusic (SQLite userdb)
* Main template to include slide out frame for login/options
* Apps/Plugins folders to be scanned on startup or on-demand

Hopefully getting some SQLite experience under my belt will help with the
Cherrymusic changes I have in mind. I should also be able to build the songdb
connector to be used by Shoutcast streams that I will get going again in the
near future.

--------------------------------------------------------------------------------
### Mon Jan 19 21:05:29 EST 2015

#### Swapping Windows 7 for Xubuntu

For the past few days my home PC has been giving me problems in Windows.
Complaining about Windows Security Essentials being turned off and I couldn't
get it to turn back on. I said fuck it, Windows has been giving me nothing but
trouble lately. I have no reason to not go to Linux full time at home. Most of
my gaming is done on the PS4 now and the few PC games that I do play are
available on Linux. So I wiped my SSD and installed Xubuntu, here I am finally
making a log update from a terminal window directly from my main PC. It's nice
to not have to SSH into a box first and then edit this log.

--------------------------------------------------------------------------------
### Sat Jan 17 23:45:46 EST 2015

#### RSDC cleanup

It only took a couple weeks worth of running full time for the music scraper
job to fill up the disk on the tools VM. I had to update the rscrape.sh job
that runs every 12hrs to include a line that finds all source files older than
14 days and removes them. This may result in some songs that I already have
getting downloaded and converted again but since the copy portion of the script
only updates the destination location I shouldn't end up with duplicates.

```
# Command to remove files older than 14 days and delete them
find /home/meder/Downloads/rsdc/in/* -mtime +14 -exec rm {} \;
```

I pull this command from a [howtogeek](
http://www.howtogeek.com/howto/ubuntu/delete-files-older-than-x-days-on-linux/)
page that that breaks down the parts of that command, although its pretty self
explanatory.

I haven't really made any further progress on CherryPy projects as I took some
time this week to play Destiny and catch up with friends. Work may be slow
tonight though so I plan on spending some more time reading docs and tinkering
with my own cherrypy-default repo.


--------------------------------------------------------------------------------
### Mon Jan 12 09:49:18 EST 2015

#### Dreaming big in CherryPy and Mako

I have all these thoughts and ideas streaming through my head since playing
with [Cherrypy][5] this weekend. I am still very much a novice in all aspects of
programming and development but I can't deny my urge to write apps for
everything I imagine. I figured I should probably try and write some of them
down for organizational purposes even if I do never get to most of them.
These apps will provide user friendly front ends to mine and others python
projects through a templating system called [Mako.][6] With Mako I can make
html templates that include some python references to get generated on the
client based on user inputs and requests.

* RaspberryPi weather, dht and thermostat apps
* rsdc music scraper app (scheduling, source selection, manual grabs)
* electric sheep type visualizer app (graphics probably beyond me)
* bill tracker/reminder app
  * (already exists with Mint and the like but still good to learn.)
* centralized link hub (bookmarks, home automation, etc.)

I think what attracts me most to the idea of developing web apps in Python +
CherryPy is how platform independant that will make them. Everyone has access
to a web browser, without even having to install anything on any current device
you can easily access the internet. Because of this web apps of this fashion
will never be limited to the crowd willing to download apps from some other
store or hub. All that would be required is knowing the url to the app and
you're ready to start using it.

In addition to these new ideas I still want to dig more through the CherryMusic
code. I'm starting to understand how the pieces fit together a little bit
better now. Reading through the CherryPy docs was initially so that I could
understand the CM server better so I suppose I should stay focused on that for
now. I do want to add to my ides for that the ability to change to a darker
theme within the CM user options page. I know now how to edit those templates
for the UI part but updating or overriding CSS is still a little over my head.
This would have to be session dependent or at least a userDB option or
something. Like I said, still much to learn when it comes to all this stuff. By
the time this is all done and I decide whether or not I can be a programmer
worth a damn, I think I'm going to need glasses. So much text to consume and
code to write!


--------------------------------------------------------------------------------
### Sat Jan 10 22:12:51 EST 2015

#### Cherrypy research

Spent some time last night reading the Cherrypy docs and API. I'm trying to get
a firm grasp on the web framework so I can better understand the changes I want
to make to CherryMusic and so going forward with the tools I build I can
incooporate them into a nice web interface. Cherrypy doesn't force you to use a
certain structure in new projects and like almost everything else in
programming there are multiple ways to do what you want to do. My struggle
right now is understanding the subject enough so as not to program myself into
a corner and have an application that can't be expanded easily. In my research
I found a project on BitBucket called
[Twiseless.](https://bitbucket.org/Lawouach/twiseless/src "Twiseless") It seems
like a good starting point for understanding how the various parts of Cherrypy
*can* work together. I like the structure of it anyway so I think going forward
I will try to setup my projects in a similar fashion. First on my list of
projects is a tool set for use at work, random string generator, account
creation tool, etc. Once I have this in place and working to a fair degree I
will turn my focus to CherryMusic. I have gotten some good feedback from the CM
devs on how to implement new database objects and together with learning the
ins and outs of Cherrypy I hope to be able to contribute to their project in the
near future.

--------------------------------------------------------------------------------
### Fri Jan  9 08:00:04 EST 2015

#### UPS -> RPi -> IPMI tool update

I realized this tool will not be able to run on the Raspberry Pi because the
linux package from CyberPower isn't available for ARM processors. I could
attempt to recompile it from the sources but I think I'd rather just write my
tool on the (x86) Ubuntu tools VM instead. I will probably just write an IPMI tool
that the pwrstat daemon can interface with when a shutdown is needed.

--------------------------------------------------------------------------------
### Tue Jan  6 23:35:52 EST 2015

- [x] Replace bad DIMM in TS2 (Bank 2 DIMM A)

I ended up just removing the bad DIMM from TS2 but at the moment it looks like
it doesn't want to boot up like that. Ill have to hook up a monitor tomorrow
and see what the deal is.

Tidying up my work spaces a bit. I need some movement in these areas from time
to time maybe just to get some new perspective or just an excuse to work at a
mindless task. I don't really know. I put the servers on their own shelves on a
wire rack today. They all sit in an open closet but they may get moved
again as I think its louder where they are now. I made a little bit of progress
on upgrading my MPC4000. I set out to put an SSD in it to get rid of the noise
old 60GB IDE drive in there. So far I haven't had any luck getting the MPC to
recognize the IDE -> SATA convertor adapter. I need to determine if the second
IDE connector on the MPC CPU board is usable or if I'm stuck using the
connector underneath the audio board.

--------------------------------------------------------------------------------
### Sun Jan  4 01:57:21 EST 2015

#### Factoring price of running servers

The new battery back-up that I have my servers connected to reports ~0.386kW
with both servers running. With this number I can calculate the energy cost to
keep these servers running. Looking at my BGE bill there is quite a list of
charges, fees, and taxes multiplied by my usage measure in kWh. Here is what my
latest bill looks like:

```
BGE Elec Supply                 682 kWh x .0857500    58.48

BGE Electric Delivery Service
Customer Charge                                       7.50
EmPower MD Chg                  682 kWh x .0041100    2.80
Distribution Chg                660 kWh x .0344000   22.70
                                 22 kWh x .0354100     .78
RSP Chg/Misc Cr                 682 kWh x .0033600    2.29
Dmd Res Chg/Cr                  682 kWh x .0002900     .20
ERI Initiative Chg              682 kWh x .0000900     .06

State / Local Taxes & Surcharges
MD Universal Svc Prog                                  .36
Envir Srchg                     682 kWh x .0001500     .10
Franchise Tax                   682 kWh x .0006200     .42
Local Tax                       682 kWh x .0077900    5.31

Total price per kWh                       .1719700
Total BGE Electric Amount                          $101.00
```

To figure out how much the servers cost to run I need to figure out how many
kWh they use per day.

```
# E(kWh) = P(kW) x t(hr)
E = 0.386 x 24 = 9.264        # kWh per day
9.264 x .17197 = 1.59313008   # $ per day
1.59313008 x 31 = 49.38703248 # $ per month
```

So about $50/month worth of electricity, assuming I keep both servers running
24/7, which I rarely do. My second server, TS2, only runs a Space-Engineers
dedicated server when I feel like playing so it isn't on all the time. This
cost is certainly manageable compared to the cost of paying a hosting company
for all of the services that I manage at home. A Space-Engineers dedicated
server, albeit better server specs than my own, can run up to $200/month. A
small VPS for running a LAMP stack for the website can be had for cheap but at
home I can run ESXi and as many VM's as my server can handle for a lot less.

The battery backup has a USB out that can be connected to a computer so that in
the event of power loss the computer(s) can be shut down safely. I plan on
using the linux tool that is available on the CyberPower website and building a
shutdown script around it to run on my RaspberryPi. The RPi can then send IPMI
commands to the Dell servers to shutdown if needed and then start back up when
normal power returns. I plan on doing some work on this script today and will
probably make a new entry once i've made some progress.

--------------------------------------------------------------------------------
### Sat Jan  3 03:26:01 EST 2015

#### Crontab update

I had to make some slight changes to my crontab on the tools VM, my scraper
script kept running multiple times an hour. Upon inspecting the crontab I had
in place the script was set to run every minute of every 6th hour, oops. I made
the changes below to set it to run once every 12hrs instead.

```
# Before
$ crontab -l
* */6 * * * /home/meder/jobs/rscrape.sh > /home/meder/jobs/rscrape.log 2>&1

# After
$ crontab -l
0 */12 * * * /home/meder/jobs/rscrape.sh > /home/meder/jobs/rscrape.log 2>&1
```

While googling around to make sure my formatting was correct I found
http://cronchecker.net, a very useful tool to spell out exactly how your cron
entry will execute.

![alt text](http://mikeder.net/img/cronChecker.PNG "Example")

--------------------------------------------------------------------------------
### Fri Jan  2 05:15:44 EST 2015

#### Minecraft VM Setup
- [x] Setup Minecraft VM on TS1

Just finished getting the Minecraft server setup in another Ubuntu 14.10 VM. It
took a bit of tinkering to get MSM, the Minecraft server management utility,
working. MSM hasn't been update in a couple years now so it doesn't know how to
install Minecraft server past version 1.5.2. This is a problem because the
current version of Minecraft is 1.8.1 and the default MSM installation will get
a 1.5.2 server up and running but thats not very useful. I found a blog post
outlining how to set up a Minecraft server on Amazon AWS and he included
details on how to patch MSM to get it working with new versions of Minecraft.

MSM documentation - http://msmhq.com/docs/commands/server.html

Blog w/ patch -
http://www.aaronbell.com/how-to-run-minecraft-server-manager-on-amazon-linux/

--------------------------------------------------------------------------------
### Fri Jan  2 02:35:39 EST 2015

#### Expanding root filesystem on Ubuntu 14.10 running on ESXi 5.5
- [x] Expand tools VM root filesystem

I knew this day would come, since the music scraper script is running full time
now the disk on my tools VM filled up pretty quickly. When I initially created
the VM I though 8GB would be plent of space to host the python tools I write
but I quickly found that running my music scraper daily will fill up 8GB in no
time. I plan on pruning the in source folder on a regular interval but until I
determine how long links stick around on various subreddits I don't want to
clear the working directory. The script checks for existing files in the in
directory before downloading any new files, if one already exists with the same
title pulled from the YouTube link, the download is skipped. Eventually the
script will store all processed links into a database so that when a subreddit
is scraped, I can check against the DB for links to skip instead of keeping the
files around. For now though expanding the root filesystem on the VM was good
practice and will work until I plan the upgrades to the music scraper.

Directions for expanding the FS were found here:
http://www.geoffstratton.com/2013/08/resize-disk-ubuntu-lvm/

--------------------------------------------------------------------------------
### Thu Jan  1 23:26:18 EST 2015

#### 2015 Projects

Getting in the first update of the New Year! I'm going to try and do an entry
to this log once a day for the rest of the year. That may be my only resolution
for now but I think logging and actively trying to work through a self
prescribed TODO list should keep me on track.

A few additions to the TODO list tonight, which I will probably tackle some of
tonight. The memory I put into TS2 is causing an amber lamp to flash on the
front of the server. This was half expected as I had the same issue with the
RAM when it was installed in TS1 but I couldn't remember which DIMM was
actually bad. So now that TS2 has been powered on for a few days it is
registering the same system event log which I can read with ipmitool.

```
61 | 12/29/2014 | 16:18:17 | Physical Security #0x52 | General Chassis intrusion | Asserted
62 | 12/29/2014 | 14:17:59 | Physical Security #0x52 | General Chassis intrusion | Deasserted
63 | 12/29/2014 | 14:29:00 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
64 | 12/29/2014 | 14:29:00 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
65 | 12/29/2014 | 14:29:00 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
66 | 12/29/2014 | 14:29:00 | Event Logging Disabled #0x06 | Correctable memory error logging disabled | Asserted
67 | 12/29/2014 | 15:33:23 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
68 | 12/29/2014 | 15:33:23 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
69 | 12/29/2014 | 15:33:23 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
6a | 12/29/2014 | 15:33:23 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
6b | 12/29/2014 | 15:33:23 | Event Logging Disabled #0x06 | Correctable memory error logging disabled | Asserted
6c | 12/29/2014 | 20:32:51 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
6d | 12/29/2014 | 20:47:07 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
6e | 12/29/2014 | 20:47:08 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
6f | 12/29/2014 | 20:47:08 | Memory #0x01 | Correctable ECC (Correctable ECC | Bank 2DIMM A) | Asserted
70 | 12/29/2014 | 20:47:08 | Event Logging Disabled #0x06 | Correctable memory error logging disabled | Asserted
```

This log shows that I opened the case on 12/29/2014 to install the RAM and then
somehow went back in time. This may be due to the server not being powered on
for a couple months. It may also indicate that the CMOS battery on the
motherboard is dead and as a result the server looses track of time when it is
unplugged. Either way the log starts showing the same error I saw on TS1 before
I replaced all the RAM in there. I'll probably be ordering anothe 16GB kit for
TS2 just to have all new memory to work with until I retire these machines.

Since I've had IPMI on my mind the past couple of days I have realized my next
project. A python/flask web app to manage these servers via ipmitool is next on
'the list'. I got a CyberPower 1500VA UPS for these servers with some Christmas
money and it has a USB port for shutting down machines safely. I figure with
this port I should be able to interface with my own ipmitool wrapper and shut
the servers down safely if the power is out for longer than the battery can
keep everything running. Right now under standard(light) load the UPS can keep
everything running for ~12min. This should be more than enough time to safely
shut everything down if need be. I may come back and update this entry once
I've done some more research on how the UPS signals shutdown via the USB port.
Once finished the ipmitool wrapper program will live on my Raspberry Pi. I plan
to eventually have all of my python projects built into a nice Flask UI and
living on the RPi for easy access. Time to commit this entry before its
tomorrow.

####Update 00:12:

Adding link for CyberPower PowerPanel Linux Manual
+ http://www.cyberpowersystems.com/user-manuals/PPL-1.2_Software_UserManual.pdf

--------------------------------------------------------------------------------
### Mon Dec 29 15:33:09 EST 2014

#### TS2 and Space Engineers

I opened up TS2 to add some extra RAM that I had laying around. This brings the
grand total to 7GB! Not really anything to brag about but any little bit helps
I guess. I also got it all updated as well as got Space Engineers to the latest
version. The update to Space Engineers last week enabled worlds with a max of
100,000km and procedural asteroids that allow for tons more shit to run into.
Just wanted to make note of these things for some reason. Not really an
important update.

#### CherryMusic development

I am going to start working on some contributions to the CherryMusic project.
One of the dev's responded to a tread I started on the project page about
adding a few features and he gave me some great info on where to start. I'm
going to start poking around and see if I can't figure out how to add a few
neat features. They are features that I had grown to like when using Winamp and
seem should be part of any music player in some way shape or form.

1. Ability to queue songs within the playlist and a queue reset button.
2. Metadata stored in a db for quicker access.
3. Playlist generator options (certain albums, artists, etc.)



--------------------------------------------------------------------------------
### Sun Dec 28 05:08:53 EST 2014

#### RSDC + rscrape.sh
- [x] Finish bash script for tools/rsdc (verbose and cronjob)

I am very pleased with how well the music-scraper script is working now. In my
first run it brought down 1.3GB worth of music. I have written a bash script
that is run every 6hrs via cron job and now the process is fully automated. The
bash script is quite simple, there is a list of subreddits to scrape and a for
loop that runs rsdc.py, copies new files over to the NAS and then cleans the
working directory before the next run. Simple and beautiful.

```
#!/bin/bash
# ~/jobs/rscrape.sh

list=(  acidhouse
        ambientmusic
        astateoftrance
        atmosphericdnb
        bigbeat
        chillmusic
        chillout
        chiptunes
        deephouse
        dnb
        dubstep
        edm
        electro
        electrohouse
        electronicdancemusic
        electronicmagic
        futurefunkairlines
        futuresynth
        house
        liquiddnb
        liquiddubstep
        psybient
        psybreaks
        psytrance
        techno
        trance
        tranceandbass )

cd /home/meder/Downloads/rsdc/out
for i in ${list[@]};
        do
                echo `date`
                echo "### Scraping /r/"$i
                /usr/local/bin/rsdc $i
                echo "### Moving new files --> /media/webrips"
                cp -Ru * /media/webrips/
                echo "Cleaning working directory before next run.."
                rm -rf /home/meder/Downloads/rsdc/out/*
        done
```

There may be a more clean way to copy and clean the files but for now this
works perfectly so I see no need to change it. I may also need to increase the
disk size on the tools VM to allow for more source file storage as I plan on
only cleaning the source/in folder weekly and at this rate the disk may fill up
before the source folder gets cleaned. I need to figure out how long it takes
for the links to drop out of the subreddits getting scraped so that I can
safely clear the source folder and not end up with duplicates. Although since
the copy portion of the script above only updates the target, if a file already
exists on the NAS it won't get copied over again.

#### Crontab

* Edited 1/2/15

```
$ crontab -l

0 */12 * * * /home/meder/jobs/rscrape.sh > /home/meder/jobs/rscrape.log 2>&1
```

Next up is the sqweeb.net/dht update. I'd like to overhaul the site and perhaps
use strapdown.js there too so its just as pretty as this page. Eventually I see
myself replacing the WordPress install with a custom page using
strapdown/bootstrap. For now though, I've got a ton of new music to listen to.

d(o.0)b

--------------------------------------------------------------------------------
### Sat Dec 27 05:34:30 EST 2014

Alright I think I've made enough progress to warrent a new entry. I decided to
use an API wrapper for interfacing with Reddit.
ReddiWrap(https://github.com/derv82/reddiwrap/) does exactly what I need and
isn't as complicated to use as PRAW. Using this also allowed me to clean up
several sections of code:

1. I could remove the duplicate filter on the scrape function since now that
I'm no longer parsing raw html with BeautifulSoup I dont get duplicates. Only 1
url is returned per post.

2. I no longer need to use BeautifulSoup! Its always a good day when you can
have few dependencies.

3. ReddiWrap incorporates limits so that I dont hit the Reddit request limit
randomly when running the script. This will finally allow me to finish my
crontab on the tools VM to scrape multiple subreddits daily.

4. I also cleaned up some unused variables and beautified the indents. Now I
feel comfortable putting a version number on this script (v1.1.0) since I won't
have to make a ton of half ass fixes unless I add new funtionality.

I haven't made this Flask friendly yet and I'm not sure how easy it will be
without breaking everything again. But, now that everything works as I intended
I will start work on making this easier to expand into UI.

#### Update 08:33 EST:

I had to make a slight change to the way the submodule ReddiWrap was handled. I
found that if I did a git clone it broke the import of Web.py. I have made a
changed to ReddiWrap.py and commited/pushed so now RSDC is at v1.1.1

--------------------------------------------------------------------------------
### Sat Dec 27 00:36:37 EST 2014

I didn't make the progress that I wanted to on the API work for RSDC(Reddit:
Scrape, Download, Convert) but I did make some improvements to the way the
current user directory is handled for generating a config and making sure the
working directories are present before downloading and converting files.
Tonight I'm going to try and make some progress on the API implementation,
although at this point I am not 100% sure ill be able to do everything I want
compared to how I handle links now but I think at least grabbing the post title
for use when generating Artist - Track info should be useful.

In addition to the RSDC script updates I'd like to look into the possiblity of
incorporating the whole script into the Flask framework so I can develop a nice
clean UI for those that don't want to use the script in the CLI. This is part
of a long term goal to have all of my utility scripts in a Web App format for
use on the RaspberryPi. Currently my RPi just hosts a simple static page that
holds some links for things on the network but eventually I would like to have
a web UI for several home automation tasks such as auto night lights and HVAC
control and such. Again, I may revisit this post as I make progress through the
night.

--------------------------------------------------------------------------------
### Fri Dec 26 01:15:55 EST 2014

Revisiting my Reddit music scraper script today to implement scraping via the
Reddit API instead of raw html parsing. I will be using the PRAW library to do
the API interaction. https://praw.readthedocs.org/en/v2.1.19/
This should hopefully clear up an issue ive started seeing when running the
script where I get a response 429, which apparently means I'm making requests
to Reddit too frequently. I should be able to pass a subreddit to PRAW have it
pull the hot links and pass them back via a json dictionary which I can then
parse for YouTube links. I will probably return to this entry once I have made
some progress on the new code.

--------------------------------------------------------------------------------
### Mon Dec 22 15:08:09 EST 2014

#### Updating .vimrc

Testing out a new .vimrc to see if it allows for proper formatting when im just
free typing into this log. There goes a nice clean line wrap so I guess its
working as I intend. Nice.

--------------------------------------------------------------------------------
### Mon Dec 22 13:59:44 EST 2014

#### Fixing a possible security hole in CherryM and Updates
- [x] Create less priveledged user for cherryM

I realized that running a music server that is open to the outside world with a
user that has sudo access and write access on my NAS was probably not the best
idea. Unfortunately I tried to implement my changes while sleep deprived, and it
resulted in accidentally removing sudo access from my main admin
account. This wouldn't have been an issue if I had done it after I had
successfully gotten the cherrymusic server running again with the less
priveledged user but I hadn't.

In order to get things going again temporarily I booted back up the old
stream(Arch) VM, and changed port forwarding again to point back at it instead.
This was a nice option that I haven't had to use before but it was nice to have a
working backup for a change when I screw something up. I went to sleep at this
point and am now writing this the following day having successfully made the
correct changes to the cherryM(Ubuntu) VM. Now the cherrymusic service runs as a
user that doesn't have access to the sudo command and the base directory for
the music folder that it accesses is no longer writable.

I have also made a few adjustments to the below procedure for setting up the
server from scratch if I ever need to do it again. In addition I made a snapshot
of the cherryM VM so that I can rollback to where it is now with everything
working nicely on a fresh install.

--------------------------------------------------------------------------------
### Thu Dec 18 11:06:35 EST 2014

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

--------------------------------------------------------------------------------
### Tue Dec 16 21:34:25 EST 2014

For some reason it seems the CherryMusic updates aren't sticking, the about page still shows 0.33.0 despite my local repo being up to date. Further investigation is required.

--------------------------------------------------------------------------------
### Tue Dec 16 08:50:25 EST 2014

This morning I actually finished the CherryMusic upgrade, I got distracted last night by an invite to do the VoG raid in Destiny. Since I had never run the raid before I jumped at the chance, its difficult for me because it requires 6
players and I dont have that many friends who play. I ended up having to leave
before we finished anyway. The stage I came in on ended up taking us several hours, probably because I was too low level to do enough damage.

Anyway the CherryMusic upgrade 0.33.0 -> 0.34.0 is done now.
Last night I was trying to do some webrips with my [Reddit music scraper script](https://github.com/sqweebking/music-scraper/blob/master/scrape.py)
and I realized I forgot the command I used for cleaning non-UTF8 characters from
the resulting files so I figured id log my process here.

```
# Scrape a subreddit for new songs
$ rsdc electronicmusic
# Move to the scraped music output directory
$ cd /home/music/scraped/out
# Run detox on all subfolders and files
$ detox -r *
# Copy all new files to the NAS(/mnt/webrips/)
$ cp -Ruv *
```

I had started to write a bash script to do this all for me so that I can just
have a cron job run it for me nightly but I ran into some issues with output
from the scraper script. Id like to retain output so that the cron emails will
give me some insight as to how the scrape is working. Another item for the TODO.

--------------------------------------------------------------------------------
### Mon Dec 15 21:38:50 EST 2014

Updating CherryMusic over @ sqweeb.net to version 0.34.0, here are the steps I used and the changelog for the latest devel version:

```
cd ~/cherrymusic
sudo git pull
sudo systemctl restart cherrymusic@meder.service
```


```
0.34.0 (2014-12-08)

 - FEATURE: sorting of queue and open playlists via dropdown menu
 - FEATURE: option to display active album art in player (thanks to @lzh9102)
 - FEATURE: enable intertial scroll on mobile (thanks to @tkafka)
 - FIXED: updated jPlayer to version 2.7.1 to fix playback on android
 - FIXED: workaround for CherryPy (>=3.3.0) bug when releasing session locks
 - FIXED: authentication for /serve resource (thanks to @susnux for spotting)
 - FIXED: album art search works with new amazon and bestbuy web sites
 - FIXED: udated tinytag to v0.7.2 to decode ID3 tags from latin1
 - FIXED: admin GUI can again create new users as admin
 - FIXED: restore "change password" functionality
 - FIXED: various problems when filecache entries no longer exist on disk
 - FIXED: some quirks in playlist age display were forcefully retired
 - FIXED: server handles bad basedir configuration gracefully
 - FIXED: updated jquery-ui to 1.11.1, does not ruin the js-compression anymore
 - FIXED: localhost_only bind address respects server.ipv6_enabled setting
 - IMPROVEMENT: transcoded tracks have a duration in player (thanks to @lzh9102)
 - IMPROVEMENT: "folder" items are now easier to click
 - IMPROVEMENT: request meta data for one track at a time to reduce server load
 - IMPROVEMENT: expand CI tests to include Python 3.4 and PyPy3
 - IMPROVEMENT: expand CI tests to more versions of CherryPy
 - IMPROVEMENT: easier pypi releases via auto-conversion of README.md -> .rst
```


--------------------------------------------------------------------------------
### Mon Dec 15 17:43:56 EST 2014

Testing out the new .vimrc as seen in:

http://youtu.be/rENXp-AWZmk?list=UUd26IHBHcbtxD7pUdnIgiCw

My .vimrc:
```
colorscheme elflord
syntax on
syntax enable
let @n = '/Log:^Mo^M^M^M^M^[kkkk80i-^[j! date^Mi### ^[^Mjzzi'

```
The last line there is important, it is the macro I can now use to start a new
entry in the log. When I press @n vim will automatically jump to the bottom of
the 'Start of Log:' line and insert a date/time stamp and put me in insert mode
ready to type out the entry. Cool stuff, all of which is still very new and
exciting to me for reasons.

###12/15/14 - Updates
- [x] DNS updated at GoDaddy.com to point mikeder.net to the github.io servers.
- [x] CNAME file in place in the repo

Thinking through updates and what not, testing TTL. The GoDaddy DNS changes
took a little longer than expected to propagate ~45min. Although this may have
been off due to my browser caching the default 404 page from github.io

Now its just a matter of learing the in's and out's of strapdown and bootstrap
to flesh out this site a bit.

###12/14/14 - Initialized
Tonight I took a few minutes to get a new github account set up to separate
from my sqweebking/sqweeb.net account and create my first repo for this website.
http://github.com/mikeder -> http://github.com/mikeder/mikeder.github.io
I then cloned this repo locally to create my index.html file. Which for now is
the only hosted file here. I still need to set up the DNS forwarding for the
GoDaddy domain mikeder.net and put a CNAME file in the repo.

###12/13/14 - Realized
Discovered github.io aka GitHub Pages via this YouTube video:
http://youtu.be/rENXp-AWZmk?list=UUd26IHBHcbtxD7pUdnIgiCw
I decided to give this a shot for my personal domain mikeder.net, which I
purchased on GoDaddy a couple of months ago. This will be used as a personal
work log and journal for things I may be working on or thinking about it my
day to day activities.
