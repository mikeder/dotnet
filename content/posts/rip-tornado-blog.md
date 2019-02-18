---
title: "RIP Tornado Blog"
date: 2019-02-17T23:00:52-05:00
categories: ["Blog"]
draft: true
tags:
  - new
  - python
  - migration
  - hugo
  - golang
---

With the final archival and consolidation of blog data's from sqweeb.net and my old mikeder.github.io pages I figured I'd write up a bit of a farewell to those formats.

<!--more-->

I started "blogging" via vim, git and python to a GitHub pages deployed site. Eventually I got bored with that and wanted to work on a bit more dynamic, python/tornado powered blog. Finally, I've landed on a Hugo powered static site deployed to AWS S3 and distributed via CloudFront. Here are some screenshots of the progression:

{{ with .Resources.ByType "image" }}
  // Resize to a height of 400px and preserve ratio
  {{ $image := $resource.Resize "x400" }} 
{{ end }}

*To be continued...*