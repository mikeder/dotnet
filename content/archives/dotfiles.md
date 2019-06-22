---
title: .dotfiles
date: 2018-10-17 01:58:16
updated: 2018-10-16 21:58:27
categories: ["Archive"]
---

:cloud: [https://github.com/mikeder/.dotfiles](https://github.com/mikeder/.dotfiles)


```bash
sudo apt-get update && \
sudo apt-get install git -y && \
git clone https://github.com/mikeder/.dotfiles.git && \
cd .dotfiles/ && rm -rf .git/ && cp -r .[!.]* .. && \
cd ~
```
