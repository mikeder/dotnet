---
title: "Vimrc Test"
date: 2014-12-15T17:43:56-05:00
categories: ["Archive"]
tags:
- blogging
- hosting
- github
- vim
---

Testing out the new .vimrc as seen in [this](http://youtu.be/rENXp-AWZmk?list=UUd26IHBHcbtxD7pUdnIgiCw) video.

My .vimrc:

```bash
colorscheme elflord
syntax on
syntax enable
let @n = '/Log:^Mo^M^M^M^M^[kkkk80i-^[j! date^Mi### ^[^Mjzzi'
```

The last line there is important, it is the macro I can now use to start a new
entry in the log. When I press @n vim will automatically jump to the bottom of
the 'Start of Log:' line and insert a date/time stamp and put me in insert mode
ready to type out the entry. Cool stuff, all of which is still very new and
exciting to me for reasons.
