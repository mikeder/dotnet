---
title: "Cherrypy Sec"
date: 2014-12-22T13:59:44-05:00
categories: ["Archive"]
tags:
- cherrymusic
- python
- Ubuntu
- virtualization
---

# Fixing a possible security hole in CherryM and Updates

- [x] Create less priveledged user for cherryM

I realized that running a music server that is open to the outside world with a
user that has sudo access and write access on my NAS was probably not the best
idea. Unfortunately I tried to implement my changes while sleep deprived, and it
resulted in accidentally removing sudo access from my main admin
account. This wouldn't have been an issue if I had done it after I had
successfully gotten the cherrymusic server running again with the less
priveledged user but I hadn't.

In order to get things going again temporarily I booted back up the old
stream(Arch) VM, and changed port forwarding again to point back at it instead.
This was a nice option that I haven't had to use before but it was nice to have a
working backup for a change when I screw something up. I went to sleep at this
point and am now writing this the following day having successfully made the
correct changes to the cherryM(Ubuntu) VM. Now the cherrymusic service runs as a
user that doesn't have access to the sudo command and the base directory for
the music folder that it accesses is no longer writable.

I have also made a few adjustments to the below procedure for setting up the
server from scratch if I ever need to do it again. In addition I made a snapshot
of the cherryM VM so that I can rollback to where it is now with everything
working nicely on a fresh install.
