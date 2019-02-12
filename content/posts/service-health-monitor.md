---
title: "Service Health Monitor"
description: "Writing a service health monitor with Go"
date: 2019-01-28T12:52:48-05:00
topics: ['Work-In-Progress']
tags:
- AWS
- cloud
- golang
- development
---

Starting a small personal project written in golang. I'd like to build a lightweight
 service health checker, similar to Pingdom. Make simple GET requests against a health
 endpoint to start, add more complex request/response checking logic in the future.
Maintain some historical data so that a spark line of repsonse time/health status can be
 shown in the front end.

 <!--more-->
Investigate:

- Scheduling periodic tasks, redis, gocron?
- AWS integration to pull all routes from an ALB
- Alerting via Slack, Discord, Email, etc. (extensible alerting channels)
- Default vs Custom health check path ( /status, /custom/path )
- Deafult vs Custom health check request (method, response introspection, etc.)
