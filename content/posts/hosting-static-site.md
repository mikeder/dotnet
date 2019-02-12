---
title: "Static Hugo Site on AWS"
date: 2019-01-20T20:50:15-05:00
description: "New attempt at a static site hosted in the cloud."
topics: ['Work-In-Progress']
tags:
- AWS
- hugo
- cloud
- web
- development
---

Notes pertaining to hosting a static site with Hugo, AWS S3 and CloudFront.

<!--more-->
Write CloudFormation template to build the following:

- [x] CloudFront Distro
- [x] S3 Bucket
- [ ] Static Site Hosting
- [x] S3 Bucket Policy
- [x] Route53 records
- [ ] CodeBuild Project
- [ ] SSM Variables ( Bucket, CDN ID, Keys )
- [ ] SSM Policy


Using CodeBuild to orchestrate the build and deploy with help from Docker and
[s3deploy](https://github.com/bep/s3deploy).

After CodeBuild project is setup, create the webhook:

```
aws codebuild create-webhook --project-name mikederdotnet
```

Add theme and remove `.git` directory from it!

Accept defeat and enable static website hosting on the S3 bucket to enforce
default root object to `index.html`.

Testing an image
![GitHubCodeBuild](/img/inprg.jpg)
