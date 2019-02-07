---
title: "Vimrc Test"
date: 2019-01-23T22:26:34-05:00
draft: true
---

### Mon Dec 15 17:43:56 EST 2014

Testing out the new .vimrc as seen in:

http://youtu.be/rENXp-AWZmk?list=UUd26IHBHcbtxD7pUdnIgiCw

My .vimrc:
```
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
