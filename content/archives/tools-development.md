---
title: "NOC Tools Development"
date: 2015-03-14T03:03:09-05:00
categories: ["Archive"]
tags:
- archive
- random
- braindump
---

# NOC Tools Development

Collecting my thoughts on tools that we could use at work. I have been
tinkering with a Shinken and Service Now script for auto ticketing alarms from
Shinken. While I've made some decent progress and have a mostly working script,
in the end it isn't very good and won't scale in our multi-poller environment.
This brings me back to the idea of a webapp or portal for tools developed and
used by the NOC. I was talking it over a bit with a coworker and he told me
about [Tornado][13] which is yet another Python web framework similar to
CherryPy. Doing some brief research on Tornado I found that in benchmark tests
it out performs CherryPy, handling more than double the requests twice as fast.
This and the fact that Tornado claims that it can 'scale to tens of thousands
of open connections' makes it seem that Tornado is likely the right choice
moving forward with this project.

My intial script tinkering made use of SQLite for ticket tracking. This handled
ticket numbers/sys_id's so that when an alarm cleared the script could do a
lookup in the database for the sysid and in turn resolve that ticket. This
works in testing, but my testing is limited to generating 1 single manual
"alarm" at a time. In reality it is very possible that multiple alarms can
trigger all at once, this is an issue for SQLite because it can't really handle
many concurrent connections. Again this just will not scale in an environment
where multiple alarms will trigger at the same time and this script needs to be
able to handle more than 1 connection at at time. My coworker suggests using
[MongoDB][14], which looks to be a good choice again. Wikipedia says MongoDB is
the most popular NoSQL database system, used by big names such as Craigslist,
eBay, Foursquare and SourceForge. It uses JSON-like database documents, called
BSON format.

Some main points on what we need as far as Shinken integration with Service
Now:

* Ability to create and resolve tickets as alarms trigger and clear.
* Gracefully handle CI's (some may be missing)
* Set all required fields for resolving ticket correctly
* Auto acknowledge alarms once ticket has been generated
* 'Oh Shit' page to mass resolve tickets if something blows up
* Database for tracking open incidents
* REST API to be called by Shinken reactioner via curl request

The ticketing system will be the primary focus of this NOC tool portal but in
addition I would still like to add some other commonly used tools:

* Player creation/deletion (studio SG accounts)
* AntHillPro build watcher (current activity, past build times, etc.)
* RNG for creating new passwords
