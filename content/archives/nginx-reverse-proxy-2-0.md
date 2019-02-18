---
title: NGINX Reverse Proxy 2.0
date: 2016-09-24 01:18:48
updated: 2016-09-24 22:45:58
categories: ["Archive"]
---

```
I realized I didn't want to have a single SSL cert covering *all* of my subdomains here @ sqweeb.net
```

So I set out on rebuilding my reverse proxy from the ground up.

I first spun up a fresh Debian 8 virtual machine, patched it up and installed [nginx and the Lets Encrypt cert bot][1]. Once the default server was up and running and I had the root certificate in place I made an ssl-defaults config file that would be included in default/root config. At this stage I also followed some advice from [SSL Labs][2] and generated a stronger dhparam.pem to be used in my ssl config.

<pre class="prettyprint">
sqweebking@proxy-02:~$ cd /etc/ssl/certs
sqweebking@proxy-02:~$ openssl dhparam -out dhparam.pem 2048
# Some sites recommend going to 4096 here but I was slightly concerned about performance,
# so I stuck with SSL Labs "at least 2,048 bits of security" requirement
</pre>

#### /etc/nginx/sites-enabled/default
* Default server config that sets up the basic reverse proxy and directory access for Lets Encrypt.

<pre class="prettyprint">
include snippets/proxy-defaults.conf;
include snippets/ssl-defaults.conf;

# Default server configuration
#
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;
        server_name _;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
        }

        location ~ /.well-known {
                # Used by Lets Encrypt to validate the server
                allow all;
        }
}
</pre>

#### /etc/nginx/snippets/proxy-defaults.conf
* Some basic reverse proxy settings included by the default server config

<pre class="prettyprint">
## Reverse proxy settings
############################

proxy_redirect off;
proxy_set_header Host $host;
proxy_set_header X-Forwarded-Proto https;
proxy_set_header X-Forwarded-Port 443;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $remote_addr;
proxy_set_header REMOTE_ADDR $remote_addr;
#proxy_http_version 1.1;
proxy_connect_timeout   600;
proxy_send_timeout      600;
proxy_read_timeout      600;
send_timeout            600;
</pre>


#### /etc/nginx/snippets/ssl-defaults.conf
* SSL settings applied to all subdomains, included by the default server config

<pre class="prettyprint">
## from https://cipherli.st/
## and https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html

ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
ssl_prefer_server_ciphers on;
#ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
ssl_ecdh_curve secp384r1;
ssl_session_cache shared:SSL:10m;
ssl_session_tickets off;
ssl_stapling on;
ssl_stapling_verify on;
resolver 192.168.1.1;
resolver_timeout 5s;
# Disable preloading HSTS for now.  You can use the commented out header line that includes
# the "preload" directive if you understand the implications.
#add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload";
add_header Strict-Transport-Security "max-age=63072000; includeSubdomains";
#add_header X-Frame-Options DENY;
add_header X-Content-Type-Options nosniff;

ssl_dhparam /etc/ssl/certs/dhparam.pem;
</pre>


Then I went about getting certs for each subdomain:
<pre class="prettyprint">
sqweebking@proxy-02:~$ sudo certbot-auto certonly -a webroot --webroot-path=/var/www/html -d alarm.sqweeb.net
sqweebking@proxy-02:~$ sudo certbot-auto certonly -a webroot --webroot-path=/var/www/html -d dht.sqweeb.net
sqweebking@proxy-02:~$ sudo certbot-auto certonly -a webroot --webroot-path=/var/www/html -d git.sqweeb.net
sqweebking@proxy-02:~$ sudo certbot-auto certonly -a webroot --webroot-path=/var/www/html -d subsonic.sqweeb.net
etc...
</pre>

After I got all of the certificates put in place I started putting together the config files for each subdomain basically following the same formula each time:

#### /etc/nginx/sites-available/sqweeb.net

<pre class="prettyprint">
## Begin server definitions
#############################

# HTTP -> HTTPS Redirect
server {
        listen         80;
        server_name sqweeb.net www.sqweeb.net;
        return 301 https://$host$request_uri;
}

# Default Server - Blog
server {
        listen          443 ssl default;
        server_name     sqweeb.net www.sqweeb.net;

        ssl_certificate /etc/letsencrypt/live/sqweeb.net/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/sqweeb.net/privkey.pem;

        set $blog_upstream "http://blog-01:8888";
        location / {
                proxy_pass $blog_upstream;
        }
}
</pre>


#### /etc/nginx/sites-available/subsonic.sqweeb.net

<pre class="prettyprint">
## Begin server definitions
#############################

# HTTP -> HTTPS Redirect
server {
        listen         80;
        server_name subsonic.sqweeb.net;
        return 301 https://$host$request_uri;
}

# Subsonic Music Server
server {
        listen          443 ssl;
        server_name     subsonic.sqweeb.net;
        client_max_body_size    500M;

        ssl_certificate /etc/letsencrypt/live/subsonic.sqweeb.net/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/subsonic.sqweeb.net/privkey.pem;

        set $subsonic_upstream "https://subsonic-02:8443";
        location / {
                proxy_pass $subsonic_upstream;
        }
}
</pre>

Each of these config files is then linked to the /sites-enabled directory:
<pre class="prettyprint">
sqweebking@proxy-02:~$ sudo ln -s /etc/nginx/sites-available/sqweeb.net /etc/nginx/sites-enabled/sqweeb.net
sqweebking@proxy-02:~$ sudo ln -s /etc/nginx/sites-available/git.sqweeb.net /etc/nginx/sites-enabled/git.sqweeb.net
sqweebking@proxy-02:~$ sudo ln -s /etc/nginx/sites-available/subsonic.sqweeb.net /etc/nginx/sites-enabled/subsonic.sqweeb.net
Etc...
</pre>

Finally tell nginx to check the config  and if all is well, reload nginx:
<pre class="prettyprint">
sqweebking@proxy-02:~$ sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
sqweebking@proxy-02:~$ sudo service nginx reload
</pre>


[NGINX Reverse Proxy 1.0](https://sqweeb.net/entry/enabling-https-with-lets-encrypt)


[1]: https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-14-04 "NGINX and Lets Encrypt"
[2]: https://github.com/ssllabs/research/wiki/SSL-and-TLS-Deployment-Best-Practices