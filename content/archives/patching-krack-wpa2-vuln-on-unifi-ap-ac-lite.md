---
title: Patching KRACK WPA2 Vuln. on UniFi AP-AC-Lite
date: 2017-10-17 22:41:48
categories: ["Archive"]
---

I tried the recommended method [here](https://help.ubnt.com/hc/en-us/articles/115013737328-Ubiquiti-Devices-KRACK-Vulnerability) without luck. When done from the UniFi controller the upgrade would just not happen, no error given as to why. I then tried it directly on the AP and found that it wasn't able to verify the SSL cert from UBNT's site.

```
BZ.v3.4.19# upgrade https://dl.ubnt.com/unifi/firmware/U7PG2/3.9.3.7537/BZ.qca956x.v3.9.3.7537.171013.1101.bin
Downloading firmware from 'https://dl.ubnt.com/unifi/firmware/U7PG2/3.9.3.7537/BZ.qca956x.v3.9.3.7537.171013.1101.bin'.

--2017-10-17 22:00:19--  https://dl.ubnt.com/unifi/firmware/U7PG2/3.9.3.7537/BZ.qca956x.v3.9.3.7537.171013.1101.bin
Resolving dl.ubnt.com... 52.84.77.57
Connecting to dl.ubnt.com|52.84.77.57|:443... connected.
ERROR: cannot verify dl.ubnt.com's certificate, issued by `/C=US/O=Amazon/OU=Server CA 1B/CN=Amazon':    
  Unable to locally verify the issuer's authority.
To connect to dl.ubnt.com insecurely, use `--no-check-certificate'.
Image short, header truncated.
Invalid firmware.
```

So I logged into another machine and pulled down the .bin file

```
meder@docker-01:~$ wget https://dl.ubnt.com/unifi/firmware/U7PG2/3.9.3.7537/BZ.q                                                ca956x.v3.9.3.7537.171013.1101.bin
--2017-10-17 22:04:03--  https://dl.ubnt.com/unifi/firmware/U7PG2/3.9.3.7537/BZ.                                                qca956x.v3.9.3.7537.171013.1101.bin
Resolving dl.ubnt.com (dl.ubnt.com)... 52.84.77.57
Connecting to dl.ubnt.com (dl.ubnt.com)|52.84.77.57|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 7452312 (7.1M) [application/octet-stream]
Saving to: ‘BZ.qca956x.v3.9.3.7537.171013.1101.bin’

BZ.qca956x.v3.9.3.7 100%[=====================>]   7.11M  21.1MB/s   in 0.3s

2017-10-17 22:04:03 (21.1 MB/s) - ‘BZ.qca956x.v3.9.3.7537.171013.1101.bin’ saved                                                 [7452312/7452312]
```

Started up a SimpleHTTPServer to serve the file locally:

```
meder@docker-01:~$ python -m SimpleHTTPServer 8001
Serving HTTP on 0.0.0.0 port 8001 ...
# Open a browser and copy the link to the .bin file just downloaded an use is as the <firmware_url>
192.168.1.38 - - [17/Oct/2017 22:15:41] "GET / HTTP/1.1" 200 -
192.168.1.38 - - [17/Oct/2017 22:15:43] "GET /BZ.qca956x.v3.9.3.7537.171013.1101.bin HTTP/1.1" 200 -

BZ.v3.4.19# upgrade http://docker-01.sqweeb.net:8001/BZ.qca956x.v3.9.3.7537.171013.1101.bin
```

This started the upgrade but was still not successful, still no indication why yet..


#### ...turns out I just had to upgrade to a lower version first.

AP started on version: `3.4.19.3477`

Upgraded Unifi controller from `4.8.20-8422` to `5.5.24-9806`

Unifi controller came back up, automatic firmware upgrade kicked in. AP upgraded to `3.8.14`

Applied custom upgrade to AP from UBNT site to `3.9.3.7537`