---
title: "Crontab Update"
date: 2019-01-23T22:18:38-05:00
draft: true
---
### Sat Jan  3 03:26:01 EST 2015

#### Crontab update

I had to make some slight changes to my crontab on the tools VM, my scraper
script kept running multiple times an hour. Upon inspecting the crontab I had
in place the script was set to run every minute of every 6th hour, oops. I made
the changes below to set it to run once every 12hrs instead.

```
# Before
$ crontab -l
* */6 * * * /home/meder/jobs/rscrape.sh > /home/meder/jobs/rscrape.log 2>&1

# After
$ crontab -l
0 */12 * * * /home/meder/jobs/rscrape.sh > /home/meder/jobs/rscrape.log 2>&1
```

While googling around to make sure my formatting was correct I found
http://cronchecker.net, a very useful tool to spell out exactly how your cron
entry will execute.
