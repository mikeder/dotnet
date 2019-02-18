---
title: Docker Shit
date: 2017-07-12 18:38:23
updated: 2017-07-12 14:38:34
categories: ["Archive"]
---

`alias docker-nuke='docker kill $(docker ps -q); docker rm $(docker ps -aq); docker rmi -f $(docker images -aq); docker volume prune -f'`

- deletes and force removes all containers, images, and volumes.