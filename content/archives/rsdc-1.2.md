---
title: "Rsdc 1"
date: 2019-01-23T22:14:36-05:00
draft: true
---

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
