---
title: "Rsdc Cleanup"
date: 2019-01-23T22:16:12-05:00
draft: true
---

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
