---
title: Ditching pfSense for a simpler approach
date: 2015-05-27 11:07:57
categories: ["Archive"]
---

I decided to just get rid of the pfSense firewall/router in my setup up in favor of just a plain squid3 reverse proxy. While pfSense does provide a nice WebUI for administering the firewall and all of the add-on's available it ended up being overly complicated for what I was trying to accomplish. Mainly I just wanted to use the reverse proxy functionality provided by the squid3 package and while it was easy to setup and get going I found that if I made one incorrect firewall rule I could easily lock myself out of the GUI and lose access to all of the servers behind the proxy. Once I started reading up more on setting up squid I realized that manually configuring a reverse proxy in yet another OpenVZ container would be easy enough.

  So I deleted the pfSense VM and set up another container with the Debian 7 template. Once the network was set up and the updates applied getting squid set up was a breeze. I really only had to deal with one config file: /etc/squid3/squid.conf and in it goes all of the cache_peer definitions (server mappings) and ACL's for providing access to the proxy via the sub domains I wanted to map to those peers, as well as ACL's for restricting access.

  Everything was up and working fairly quickly but I soon discovered an issue when I tried to commit and push a blog update to my internal GitLab server. I was unable to login via the command line when prompted. I kept getting authentication failed, this was not the case before I set up the proxy so I knew it had to be related to my new configuration. After some quick googling I found that I needed to add the "login=PASS" to the option list in the cache_peer lines for git.sqweeb.net:

```
# Define servers that will use the proxy
cache_peer git.sqweeb.net parent 80 0 no-query originserver login=PASS name=git
```