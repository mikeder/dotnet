---
title: "RSDC v1.2"
date: 2015-01-24T09:44:56-05:00
categories: ["Archive"]
tags:
- reddit
- music
- development
- python
- scraping
- randomver
---

# RSDC v1.2

I have finished the SQLite3 integration into the RSDC script. For now it isn't
in plugin form because I wanted to just push to get it working. Now that I have
all of the originally intended functionality working I can work on breaking it
out to work with a cherrypy install. For now though I'm very pleased with how
well the script works. In addition to the script changes I found that pafy had
a few updates since I last installed it so I upgraded from v0.3.64 -> v0.3.68
which seems to have fixed a bug where YouTube would give a 403 Forbidden error
on certain videos.
