---
title: "RSDC & Cherrypy"
date: 2015-01-24T00:58:25-05:00
categories: ["Archive"]
tags:
- reddit
- music
- development
- python
- scraping
- cherrypy
---

# More RSDC tweaks and CherryPy thoughts

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
