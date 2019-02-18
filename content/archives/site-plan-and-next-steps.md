---
title: Site plan and next steps
date: 2015-05-09 02:19:27
categories: ["Archive"]
---

I plan on this blog being an on going project that will evolve into a portal of sorts for my personal coding projects. Step one was getting the blog up and running to have a place to document my work and also have a starting point from which to branch out into the custom website I have envisioned. Here i will tie together the small programming projects that I come up with and provide them with a decent looking front end as so far i have really only dealt with the server side and command line aspect.

My next steps will probably include resurrecting some old posts from my previous Wordpress installation just to retain some information on the projects I had mentioned in them. After that will come the building out of modules or plugins for this site, this blog being the first main module. This basic blog module still needs much improvement, right now config options are directly set inside blog.py, which also functions as the server itself. I would like to break out these config setting into their own config file that will get read by a separate blog module that will be handled by a separate server. The idea here is to make this site as modular as possible so that individual pieces can be worked and reworked without breaking functionality elsewhere. Ideally my structure would look something like this:

```
portal/
- server.py
- config.json
portal/modules/
- admin/
- blog/
- gallery/
- streams/
portal/plugins/
- database/
- graphing/
- music-scraper/
```

The admin module would extend the server functionality but should not necessarily be required for it to function. I'm thinking it will probably be useful for giving the configuration a front end, for things like adding and enabling modules, plugins and end-points. I'll probably find that this approach is not the best but hopefully I will have everything modular and plug and play enough so that a major overhaul isn't required down the road...

Blog module improvement ideas:

* Post tagging functionality (#hashtags and /tags endpoint)
* Tag based searching
* Simple image uploading and linking

I would also like to move from MySQL to SQLite3 just to make things simpler when installing this blog app but I haven't really done my homework on this yet and there is probably good reason why the folks at Tornado have used MySQL in their demo.