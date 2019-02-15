---
title: "RSDC Scripting"
date: 2014-12-28T05:08:53-05:00
categories: ["Archive"]
tags:
- sysadmin
- linux
- music
- bash
- scripting
- scraping
---

# RSDC + rscrape.sh

- [x] Finish bash script for tools/rsdc (verbose and cronjob)

I am very pleased with how well the music-scraper script is working now. In my
first run it brought down 1.3GB worth of music. I have written a bash script
that is run every 6hrs via cron job and now the process is fully automated. The
bash script is quite simple, there is a list of subreddits to scrape and a for
loop that runs rsdc.py, copies new files over to the NAS and then cleans the
working directory before the next run. Simple and beautiful.

```bash
#!/bin/bash
# ~/jobs/rscrape.sh

list=(  acidhouse
        ambientmusic
        astateoftrance
        atmosphericdnb
        bigbeat
        chillmusic
        chillout
        chiptunes
        deephouse
        dnb
        dubstep
        edm
        electro
        electrohouse
        electronicdancemusic
        electronicmagic
        futurefunkairlines
        futuresynth
        house
        liquiddnb
        liquiddubstep
        psybient
        psybreaks
        psytrance
        techno
        trance
        tranceandbass )

cd /home/meder/Downloads/rsdc/out
for i in ${list[@]};
        do
                echo `date`
                echo "### Scraping /r/"$i
                /usr/local/bin/rsdc $i
                echo "### Moving new files --> /media/webrips"
                cp -Ru * /media/webrips/
                echo "Cleaning working directory before next run.."
                rm -rf /home/meder/Downloads/rsdc/out/*
        done
```

There may be a more clean way to copy and clean the files but for now this
works perfectly so I see no need to change it. I may also need to increase the
disk size on the tools VM to allow for more source file storage as I plan on
only cleaning the source/in folder weekly and at this rate the disk may fill up
before the source folder gets cleaned. I need to figure out how long it takes
for the links to drop out of the subreddits getting scraped so that I can
safely clear the source folder and not end up with duplicates. Although since
the copy portion of the script above only updates the target, if a file already
exists on the NAS it won't get copied over again.

## Crontab

- Edited 1/2/15

```bash
$ crontab -l

0 */12 * * * /home/meder/jobs/rscrape.sh > /home/meder/jobs/rscrape.log 2>&1
```

Next up is the sqweeb.net/dht update. I'd like to overhaul the site and perhaps
use strapdown.js there too so its just as pretty as this page. Eventually I see
myself replacing the WordPress install with a custom page using
strapdown/bootstrap. For now though, I've got a ton of new music to listen to.

d(o.0)b
