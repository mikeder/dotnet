---
title: "Writing a data mover in Go"
date: 2019-02-17T15:34:34-05:00
categories: ["Blog"]
tags:
  - new
  - Golang
  - blog
  - development
---

I needed a tool to move some old tornado blog posts from its mysql database into the archive here. I'm going to use this as an opportunity to practice writing some Go that talks to a database and writes out to a file on disk.

:cloud: https://github.com/mikeder/blogshovel

<!--more-->

First I need to learn how to connect to a database in Go.

Starting with [this](https://tutorialedge.net/golang/golang-mysql-tutorial/) tutorial.

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

I ended up writing an empty `Database` struct with a `getPosts()` method to retrieve all of the entries from my database. This works for now, I'll have to come back and clean up its setup to take CLI args instead of a hard-coded connection string.

```go
type Database struct {
	Type             string
	ConnectionString string
}

func (d *Database) getPosts() ([]Post, error) {
	db, err := sql.Open(d.Type, d.ConnectionString)
	if err != nil {
		return nil, err
	}
	defer db.Close()

	results, err := db.Query("SELECT * FROM entries")
	if err != nil {
		return nil, err
	}
	var posts []Post
	for results.Next() {
		var post Post
		err = results.Scan(
			&post.ID,
			&post.Author,
			&post.Slug,
			&post.Title,
			&post.Markdown,
			&post.HTML,
			&post.Published,
			&post.Updated,
		)
		if err != nil {
			return posts, err
		}
		posts = append(posts, post)
	}
	return posts, nil
}
```

Next I need to figure out how to write my slice of Posts out to disk as markdown. Ideally the resulting markdown files would be properly formatted for my Archive archetype here on this blog.

For writing out, I ended up just putting together a byte slice to then write out to file directly. Nothing fancy here just adding up a bunch of strings and writing them to disk.

```go
func (a *Archive) write() error {
	data := []byte(
		"---\n" +
		a.Title + "\n" +
		a.Date + "\n" +
		a.Updated + "\n" +
		"categories: [\"Archive\"]\n" +
		"---\n" +
		"\n" +
		a.Body)
	fmt.Printf("Writing %v\n", a.Filename)
	err := ioutil.WriteFile(a.Filename, data, 0644)
	if err != nil {
		return err
	}
	return nil
}
```

I came back a bit later to add the `-outdir` flag to be used in the output path.

### Note - If the directory used in `-outdir` doesn't exist, the write operation fails silently.

At this point I have pretty much accomplished my goal, just need some cleanup around passing in the database connection string. Maybe in the future I'll expand on this to be able to move data from different types of sources with an interface of `PostReader` and `ArchiveWriter` but its good enough for now.
