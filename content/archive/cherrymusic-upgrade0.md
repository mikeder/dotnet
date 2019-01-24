---
title: "Cherrymusic Upgrade0"
date: 2019-01-23T22:26:12-05:00
draft: true
---

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
