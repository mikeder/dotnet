---
title: "Service Health Monitor"
description: "Writing a service health monitor with Go"
date: 2019-01-28T12:52:48-05:00
draft: true
tags:
- AWS
- cloud
- golang
- development
---

Investigate:

- Scheduling periodic tasks, redis, gocron?
- AWS integration to pull all routes from an ALB
- Alerting via Slack, Discord, Email, etc. (extensible alerting channels)
- Default vs Custom health check path ( /status, /custom/path )
- Deafult vs Custom health check request (method, response introspection, etc.)
