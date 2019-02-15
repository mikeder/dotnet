---
title: "Minecraft VM Notes"
date: 2015-01-02T05:15:44-05:00
categories: ["Archive"]
---

# Minecraft VM Setup

- [x] Setup Minecraft VM on TS1

Just finished getting the Minecraft server setup in another Ubuntu 14.10 VM. It
took a bit of tinkering to get MSM, the Minecraft server management utility,
working. MSM hasn't been update in a couple years now so it doesn't know how to
install Minecraft server past version 1.5.2. This is a problem because the
current version of Minecraft is 1.8.1 and the default MSM installation will get
a 1.5.2 server up and running but thats not very useful. I found a blog post
outlining how to set up a Minecraft server on Amazon AWS and he included
details on how to patch MSM to get it working with new versions of Minecraft.

MSM documentation - [Minecraft Server Manager](http://msmhq.com/docs/commands/server.html)

Blog w/ patch -
[Minecraft on AWS](http://www.aaronbell.com/how-to-run-minecraft-server-manager-on-amazon-linux/)
