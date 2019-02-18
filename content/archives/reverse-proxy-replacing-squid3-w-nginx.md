---
title: Replacing squid3 w/ nginx reverse proxy
date: 2015-06-29 08:02:12
categories: ["Archive"]
---

When I was using the squid3 package in pfSense it came configured ready to use SSL and you could just import your cert's or let it generate one for you and it just worked. Then I decided to swap out pfSense for a basic squid3 proxy, which at first was great. Configuration was super simple and I had it up and running in a matter of minutes, for most of my backend anyway. I quickly realized that squid3 did not come compiled with SSL support and this meant I couldn't proxy to servers running on HTTPS (airtime, proxmox, etc). No problem, there is plenty of documentation out there on how to recompile with SSL support and where to put certs and all that. Problem was, I couldn't for the life of me get it to work. I would compile and recompile and squid would never end up with SSL support.

```
root@proxy:~# squid3 -v | grep ssl                                                          
root@proxy:~#
# Nothing?!
```

So I set out to find another option, I knew that nginx could perform reverse proxy functions but at first look it looked more complicated than squid. Having another look it didn't seem so bad, and I was bored at work tonight, so I figured I'd give it a shot. I set up a fresh Debian 7 container and went through the normal procedure of setting up DHCP, reserving the address on the router and updating packages. I roughly followed <a href="https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0CB4QFjAA&url=https%3A%2F%2Fwww.digitalocean.com%2Fcommunity%2Ftutorials%2Fhow-to-configure-nginx-with-ssl-as-a-reverse-proxy-for-jenkins&ei=yu-PVcXjHom1-AHnyoHwBA&usg=AFQjCNFm-Gp9L4Fi2F7wruE3yZfxXyXntw&sig2=NIIfG8AfQpRUYA5mkCQNnA">this tutorial</a> to get nginx installed and a new SSL cert in place.

```
root@proxy:~# apt-get install nginx
root@proxy:~# cd /etc/nginx
root@proxy:~# sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/cert.key -out /etc/nginx/cert.crt
```

Once nginx was installed it was just a matter of creating a new site file in /etc/nginx/sites-availalable with my configuration:

```
# /etc/nginx/sites-available/sqweebnet

# Reverse proxy settings
proxy_redirect off;
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $remote_addr;

## List upstream servers ##
# Airtme server
upstream airtime {
    server airtime.sqweeb.net:443;
}
# Blog server
upstream blog {
    server blog.sqweeb.net:8888;
}
# CherryMusic server
upstream cherrym {
    server cherrym.sqweeb.net:8080;
}
# DHT sensor
upstream dht {
    server dht.sqweeb.net;
}
# GitLab server
upstream gitlab {
    server git.sqweeb.net;
}                                                                                                                                                                                                                                                                                      ## Begin server definitions ##
server {
    listen 443 ssl;
    server_name airtime.sqweeb.net;
    ssl_certificate /etc/nginx/cert.crt;
    ssl_certificate_key /etc/nginx/cert.key;
    ssl on;
    ssl_session_cache builtin:1000 shared:SSL:10m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
    ssl_prefer_server_ciphers on;
    location / {
        proxy_ssl_session_reuse off;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_pass https://airtime;
        proxy_read_timeout 90;
    }
}
server {
    listen 80;
    server_name www.sqweeb.net;
    location / {
        proxy_pass http://blog;
    }
}
server {
    listen 80;
    server_name git.sqweeb.net;
    location / {
        proxy_pass http://git;
    }
}
server {
    listen 80;
    server_name cherry.sqweeb.net;
    location / {
        proxy_pass http://cherrym;
    }
}
server {
    listen 80;
    server_name dht.sqweeb.net;
    location / {
        proxy_pass http://dht;
    }
}            
```

After the config is in place I just make a symbolic link to the /sites-enabled folder and restart nginx.
```
root@nginx-proxy:~# ln -s /etc/nginx/sites-available/sqweebnet /etc/nginx/sites-enabled/sqweebnet
root@nginx-proxy:~# service nginx restart
Restarting nginx: nginx.
```

This whole process was fairly painless, and shockingly it worked right off the bat, no troubleshooting required. I'm not sure if my config is 100% correct w/ regards to the reverse proxy settings at the top but everything seems to work as expected. Also as a nice side effect, nginx happens to use about 1/2 the memory that squid did, even while serving request through SSL encryption, that and the fact that it worked without any headache what so ever make me wonder why I didn't try this earlier. Now that I can proxy to HTTPS enabled servers I can start using Airtime again, so the <a href="/radio">radio page</a> is working again! :D
