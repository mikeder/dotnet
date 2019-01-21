---
title: "Hosting Static Site"
date: 2019-01-20T20:50:15-05:00
draft: false
tags:
- AWS
- cloud
- web
- development
---

Hosting a static site with Hugo, AWS S3 and CloudFront.

Write CloudFormation template to build the following:

- [x] CloudFront Distro
- [x] S3 Bucket
- [x] S3 Bucket Policy
- [x] Route53 records
- [ ] ~API Gateway for webhook trigger~ `not needed`
- [ ]  CodeBuild Project



Using CodeBuild to orchestrate the build and deploy with help from Docker and
[s3deploy](https://github.com/bep/s3deploy).

After CodeBuild project is setup, create the webhook:

```
aws codebuild create-webhook --project-name mikederdotnet
```

Add theme and remove `.git` directory from it!

Accept defeat and enable static website hosting on the S3 bucket to enforce
default root object to `index.html`.

Do moar things
