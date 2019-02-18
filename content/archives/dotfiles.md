---
title: .dotfiles
date: 2018-10-16 21:58:27
categories: ["Archive"]
---

```bash
sudo apt-get update && \
sudo apt-get install git -y && \
git clone https://github.com/mikeder/.dotfiles.git && \
cd .dotfiles/ && rm -rf .git/ && cp -r .[!.]* .. && \
cd ~
```