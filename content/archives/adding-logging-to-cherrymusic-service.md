---
title: Adding logging to CherryMusic service
date: 2015-05-30 08:18:54
categories: ["Archive"]
---

This morning I added some logging functionality to the [Cherrymusic service script](https://github.com/mikeder/cherrymusic-conf/tree/add-log) that lives in `/etc/init.d/cherrymusic`. I have a couple issues going on with the music server that are going to require some log digging. One of which I've already fixed: Some of the Web Rips sub directories would open up empty. Upon review the logs when accessing those folders I found this:

```bash
[150521-14:10] ERROR   : [21/May/2015:14:10:41] HTTP Traceback (most recent call last):
  File "/home/cherrymusic/cherrymusic-devel/cherrypy/_cprequest.py", line 656, in respond
    response.body = self.handler()
  File "/home/cherrymusic/cherrymusic-devel/cherrypy/lib/encoding.py", line 188, in __call__
    self.body = self.oldhandler(*args, **kwargs)
  File "/home/cherrymusic/cherrymusic-devel/cherrypy/_cpdispatch.py", line 34, in __call__
    return self.callable(*self.args, **self.kwargs)
  File "/home/cherrymusic/cherrymusic-devel/cherrymusicserver/httphandler.py", line 291, in api
    return json.dumps({'data': handler(**handler_args)})
  File "/home/cherrymusic/cherrymusic-devel/cherrymusicserver/httphandler.py", line 471, in api_compactlistdir
    return [entry.to_dict() for entry in files_to_list]
  File "/home/cherrymusic/cherrymusic-devel/cherrymusicserver/httphandler.py", line 471, in <listcomp>
    return [entry.to_dict() for entry in files_to_list]
  File "/home/cherrymusic/cherrymusic-devel/cherrymusicserver/cherrymodel.py", line 401, in to_dict
    urlpath = quote(self.path.encode('utf8'))
UnicodeEncodeError: 'utf-8' codec can't encode character '\udce2' in position 29: surrogates not allowed
```

This is obviously because my filename sanitizing in the music-scraper script I use is lacking. So I found a decent bash script for renaming filenames that contain invalid characters.

```bash
#!/usr/bin/env bash
find "$1" -depth -print0 | while IFS= read -r -d '' file; do
  d="$( dirname "$file" )"
  f="$( basename "$file" )"
  new="${f//[^a-zA-Z0-9\/\. \&_()\-]/}"
  if [ "$f" != "$new" ]      # if equal, name is already clean, so leave alone
  then
    if [ -e "$d/$new" ]
    then
      echo "Notice: \"$new\" and \"$f\" both exist in "$d":"
      ls -ld "$d/$new" "$d/$f"
    else
      echo mv "$file" "$d/$new"      # remove "echo" to actually rename things
    fi
  fi
done
```

I saved this script in /home/cherrymusic so I can run it if I start to see this issue again but ideally I'd like to fix the music-scraper script so it doesn't allow these characters through in the first place.

```bash
# Dump all filenames to be changed into a text file to be reviewed
cherrymusic@cherrym-ct:~$ ./rename.sh /mnt/vm-storage-1/Music/Web\ Rips > rename.txt
```

Once everything was looking good in the test run dump into replace.txt I removed the "echo" from the mv command in the rename script and ran it again to actually perform the renaming.

Finally I added a cron job to be run daily to rotate the cherrymusic log files so they don't get too huge. I still need to add another line to remove logs older than a week or so, but that can wait a bit.

```
# m h  dom mon dow   command
@daily /home/cherrymusic/logrotate.sh
```
