---
title: Photo sorting is dangerous business
date: 2018-07-13 01:37:31
updated: 2018-07-29 22:05:53
categories: ["Archive"]
---

```
find . -type f -iname \*.JPG -print0 | xargs -0 -I '{}' /bin/mv "{}" ../JPG/
```

will overwrite your shit if filenames are the same!