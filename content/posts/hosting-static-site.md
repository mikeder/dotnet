---
title: "Static Hugo Site on AWS"
date: 2019-01-20T20:50:15-05:00
description: "New attempt at a static site hosted in the cloud."
categories: ["Blog", "Work-In-Progress"]
draft: true
tags:
- AWS
- hugo
- cloud
- web
- development
---

Notes pertaining to hosting a static site with Hugo, AWS S3 and CloudFront.

GitHub repo for this project is self contained, content and build pipeline all in one.

:cloud: [https://github.com/mikeder/dotnet](https://github.com/mikeder/dotnet)

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

```bash
aws codebuild create-webhook --project-name mikederdotnet
```

Add theme and remove `.git` directory from it!

Accept defeat and enable static website hosting on the S3 bucket to enforce
default root object to `index.html`.

Testing an image
![GitHubCodeBuild](/img/inprg.jpg)

By including the code build status image in the readme, I can check at a glance that the most recent build was successful. (They always are.)
