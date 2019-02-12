---
title: "Braindump Dev Linux"
date: 2015-01-31T00:11:38-05:00
categories: ["Archive"]
tags:
- linux
- cherrypy
- development
---

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
