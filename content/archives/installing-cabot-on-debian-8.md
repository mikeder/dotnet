---
title: Installing Cabot on Debian 8
date: 2016-10-12 14:00:37
updated: 2016-10-28 11:16:04
categories: ["Archive"]
---

https://www.unicoda.com/?p=1624

<pre class="prettyprint">
sudo apt-get install python-dev python-pip postgresql ruby
sudo pip install ecdsa fabric pycrypto
git clone https://github.com/lincolnloop/cabot.git
cd cabot
cp conf/production.env.example conf/production.env
# Add at least graphite url and login to config
nano env/production.env
fab provision -H root@localhost
fab deploy -H ubuntu@localhost

su - ubuntu
source /home/ubuntu/venv/bin/activate
cd cabot
foreman start -e conf/production.env

</pre>

Modifying fabric provision/deploy for multi instance deploys:

* Clone official repo
* Make new local branch - 'tesl'
* Find/replace all instances of ubuntu with tesl in fabfile.py and bin/setup_dependencies.sh
* EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend' in cabot/settings.py
* Comment out SES_ settings in conf/production.env

## 10/28/16 Edit - Deploy using docker-compose for easier management of multiple backends

I needed to be able to support monitoring of multiple graphite servers, and since Cabot can't do this out of the box I had to find a solution to deploy multiple instances of Cabot in a more manageable fashion. The official way to deploy with Docker points to [this repo](https://github.com/shoonoise/cabot-docker), this deploy method is mostly complete but there were some inconsistencies in the way environment variables were defined. There were also a number of useful variables missing from the env_file that I felt should still be there, even if they're commented out. I [forked this repo](https://github.com/mikeder/cabot-docker) and made some slight adjustments to accomplish a few things:

* Give meaningful names to containers for easier identification/log diving/management 
* Install cabot_alert_slack alert plugin while building app container
* Include slack related environment variables in cabot_env (env_file)
* Include default environment variables in env_file, removed duplicates from Cabot/Dockerfile