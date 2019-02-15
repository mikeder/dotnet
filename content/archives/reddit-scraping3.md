---
title: "Reddit Scraping pt. 3"
date: 2014-12-27T05:34:30-05:00
categories: ["Archive"]
tags:
- reddit
- music
- development
- python
- scraping
---

# Mid Shift Progress Update

Alright I think I've made enough progress to warrent a new entry. I decided to
use an API wrapper for interfacing with Reddit.
[ReddiWrap](https://github.com/derv82/reddiwrap/) does exactly what I need and
isn't as complicated to use as PRAW. Using this also allowed me to clean up
several sections of code:

1. I could remove the duplicate filter on the scrape function since now that
I'm no longer parsing raw html with BeautifulSoup I dont get duplicates. Only 1
url is returned per post.

2. I no longer need to use BeautifulSoup! Its always a good day when you can
have few dependencies.

3. ReddiWrap incorporates limits so that I dont hit the Reddit request limit
randomly when running the script. This will finally allow me to finish my
crontab on the tools VM to scrape multiple subreddits daily.

4. I also cleaned up some unused variables and beautified the indents. Now I
feel comfortable putting a version number on this script (v1.1.0) since I won't
have to make a ton of half ass fixes unless I add new funtionality.

I haven't made this Flask friendly yet and I'm not sure how easy it will be
without breaking everything again. But, now that everything works as I intended
I will start work on making this easier to expand into UI.

## Update 08:33 EST:

I had to make a slight change to the way the submodule ReddiWrap was handled. I
found that if I did a git clone it broke the import of Web.py. I have made a
changed to ReddiWrap.py and commited/pushed so now RSDC is at v1.1.1
