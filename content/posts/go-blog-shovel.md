---
title: "Go Blog Shovel"
date: 2019-02-17T15:34:34-05:00
draft: true
tags:
  - new
categories: ["Development", "Golang"]
---

# Writing a data mover in Go

I need a tool to move some old tornado blog posts from its mysql database into the archive here. I'm going to use this as an opertunity to practice writing some Go that talks to a database and writes out to a file on disk.

<!--more-->


First I need to learn how to connect to a database in Go.

Starting with (this)[https://tutorialedge.net/golang/golang-mysql-tutorial/] tutorial.

*Right* after I update my development VM go installation, apparently the `go-sql-driver` doesn't support go 1.7, which of course is what I had to start.

```bash
# Remove original install
$ sudo apt remove golang
$ sudo rm /usr/local/go/
# Get golang .tar from golang.org
$ wget https://dl.google.com/go/go1.11.5.linux-amd64.tar.gz
# Unpack tar to /usr/local/go/
$ sudo tar -C /usr/local -xzf go1.11.5.linux-amd64.tar.gz
# Update PATH to include new go binary
$ export PATH=$PATH:/usr/local/go/bin
# Set GOPATH
$ export GOPATH=/home/meder/go
# Finally install go-sql-driver - https://github.com/go-sql-driver/mysql
$ go get -u github.com/go-sql-driver/mysql
```

Ill be connecting to a mysql vm, with blog user credentials, to retrieve everything in the entry/posts table. Then, populating structs with the fields that I want to preserve and then writing those out to disk as markdown, to finally be archived in this repo with the rest of my ramblings.

I ended up writing an empty `Database` struct with a `getPosts()` method to retrieve all of the entries from my database. This works for now, I'll have to come back and clean up its setup to take CLI args instead of a hardcoded connection string.

```go

```

Next I need to figure out how to write my slice of Posts out to disk as markdown. Ideally the resulting markdown files would be properly formatted for my Archive archetype here on this blog.



