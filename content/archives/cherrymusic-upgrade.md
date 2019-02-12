---
title: "Cherrymusic Upgrade"
date: 2014-12-16T08:50:25-05:00
categories: ["Archive"]
tags:
- Cherrymusic
- linux
- sysadmin
- music
---


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
