---
title: Fixing CherryMusic filename decoding errors
date: 2015-05-30 10:15:10
updated: 2015-06-01 15:46:25
categories: ["Archive"]
---

I recently came across a strange problem with the CherryMusic server that only appeared when it was started via an /etc/init.d script. In certain folders the tracks would not show, although the folder showed that there were files within, when you clicked on the folder it would just open an empty list. This condition would also be accompanied by the following error in the logs:
<pre class="prettyprint">
UnicodeEncodeError: 'utf-8' codec can't encode character '\udce2' in position 29: surrogates not allowed 
</pre>

Doing some quick Google-Fu I came across <a href="http://www.dangtrinh.com/2014/10/running-cherrymusic-as-service-in.html" target="_blank">this page</a> which states that this is caused by a <a href="https://bugs.launchpad.net/ubuntu/+source/apport/+bug/1227381" target="_blank">bug</a> in Python3, but the bug has apparently already been fixed. So I went searching again to figure out how to run the cherrymusic service with LC_CTYPE="en_US.UTF-8" set in the environment, which lead me to <a href="http://www.logikdev.com/2010/02/02/locale-settings-for-your-cron-job/" target="_blank">this page.</a>

I checked the locale settings on the cherry container, which looked correct:
<pre class="prettyprint">
root@cherrym:/# locale
LANG=en_US.UTF-8
LANGUAGE=
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_ALL=
</pre>

So as suggested in the comments of that page I just redirected the output of locale to /etc/environment and /etc/default/locale :
<pre class="prettyprint">
root@cherrym:/# locale > /etc/environment
root@cherrym:/# locale > /etc/default/locale
root@cherrym:/# service cherrymusic restart
[ ok ] Restarting CherryMusic...: cherrymusic.
</pre>

After this all of the folders show their contents as expected and there are no more 'UnicodeEncodeErrors' showing up in the log :)