---
title: "Reddit Scraping pt. 2"
date: 2014-12-27T00:36:37-05:00
categories: ["Archive"]
tags:
- reddit
- music
- development
- python
- scraping
---

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
