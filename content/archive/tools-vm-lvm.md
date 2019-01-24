---
title: "Tools Vm Linux"
date: 2019-01-23T22:19:46-05:00
draft: true
---

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
