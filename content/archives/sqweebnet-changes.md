---
title: "Sqweebnet Changes"
date: 2019-01-23T22:14:08-05:00
draft: true
---

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
