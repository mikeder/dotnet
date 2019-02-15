---
title: "Reddit Scraping pt. 1"
date: 2014-12-26T01:15:55-05:00
categories: ["Archive"]
tags:
- reddit
- music
- development
- python
- scraping
---

Revisiting my Reddit music scraper script today to implement scraping via the
Reddit API instead of raw html parsing. I will be using the PRAW library to do
the API interaction. [PRAW Docs](https://praw.readthedocs.org/en/v2.1.19/)
This should hopefully clear up an issue ive started seeing when running the
script where I get a response 429, which apparently means I'm making requests
to Reddit too frequently. I should be able to pass a subreddit to PRAW have it
pull the hot links and pass them back via a json dictionary which I can then
parse for YouTube links. I will probably return to this entry once I have made
some progress on the new code.
