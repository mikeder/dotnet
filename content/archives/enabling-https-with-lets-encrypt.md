---
title: Enabling HTTPS with Lets Encrypt
date: 2016-02-11 07:10:19
categories: ["Archive"]
---

[Lets Encrypt](https://letsencrypt.org/) has made it super simple to create and install ssl certificates so I decided to finally make the jump to https. They have developed an auto installer client that is already working for Apache but apparently the NGINX installer is still under development. They also give you the option of just generating certs and installing them manually so that's what I opted to do.

First I cloned the [Lets Encrypt GitHub](https://github.com/letsencrypt/letsencrypt) repo to my NGINX proxy box and then generate a certificate chain for each of my sub-domain's.

```
root@proxy-01:~# git clone https://github.com/letsencrypt/letsencrypt
root@proxy-01:~# cd letsencrypt/
./letsencrypt-auto certonly --standalone -d sqweeb.net -d git.sqweeb.net -d subsonic.sqweeb.net -d wekan.sqweeb.net -d cherry.sqweeb.net -d www.sqweeb.net
```

This gave me an error that port 80 was already in use:
```
The program nginx (process ID 4510) is already listening on TCP port x
   x 80. This will prevent us from binding to that port. Please stop the  x
   x nginx program temporarily and then try again.
```

It is required to stop the web server or in this case, proxy, to get around this error: 

(note: this may not be necessary in the future once the NGINX installer is finished as I don't think it is necessary for the Apache installer)
```
root@proxy-01:~/letsencrypt# service nginx stop
Stopping nginx: nginx.
```

Rerun the letsencrypt script:
```
./letsencrypt-auto certonly --standalone -d sqweeb.net -d git.sqweeb.net -d subsonic.sqweeb.net -d wekan.sqweeb.net -d cherry.sqweeb.net -d www.sqweeb.net
```

This will put the certificate chain in /etc/letsencrypt/live/sqweeb.net ready to be used by NGINX. From here it is just a matter of swapping out the self signed certificate I was using for this newly generated cert.

```
#/etc/nginx/sites-available/sqweebnet

## SSL server settings
############################

#ssl on;
ssl_certificate /etc/letsencrypt/live/sqweeb.net/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/sqweeb.net/privkey.pem;
ssl_session_cache builtin:1000 shared:SSL:10m;
ssl_protocols TLSv1.1 TLSv1.2;
ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!3DES:!MD5:!PSK';
ssl_prefer_server_ciphers on;
```

I also enabled a HTTP -> HTTPS redirect so all of the requests to upstream servers handled by this proxy would now be using SSL, instead of a select few that require it.

```
#/etc/nginx/sites-available/sqweebnet

# HTTP -> HTTPS Redirect
server {
        error_log /var/log/nginx/error.log info;
        listen         80;
        return 301 https://$host$request_uri;
}

# Once all the config changes are made, restart the nginx service:
root@proxy-01:~# service nginx start
Starting nginx: nginx.
```

Now https is working across all of my subdomains! Only gripe is the subsonic app on my phone doesn't seem to be able to connect to [https://subsonic.sqweeb.net](https://subsonic.sqweeb.net) whereas my girlfriends phone can. This may require some updating of OS and/or more digging but I will update this post once its sorted out.

*Edit*
I resolved the Subsonic app connection issue on my phone by updating to the latest Android OS. I can now stream over https just as I could before over http.