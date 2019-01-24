---
title: "Graphite Data Retention"
date: 2015-02-19T08:14:56-05:00
tags:
- homelab
- graphite
- metrics
- dashboards
---

#### Increasing Graphite data retention

Lengthening the storage time for graphite metrics, default is 1 second
resolution for 1 day. The new schema will be as follows:

```
# /opt/graphite/conf/storage-schemas.conf

[sqweeb]
pattern = .*
retentions = 1s:1d,1m:7d,5m:30d
```

This will allow me to see more overall trending views on Grafana while still
keeping the tight 1 second resolution for checking out spikes.

#### 08:50 update

Two things were found out while making the storage-schema change above:

1. Just chaging storage-schema.conf and restarting carbon-cache.py is not
enough to get the changes in place. (further investigation required)

I suspected this may be a problem because the graphite docs did mention that
the whisper data files are preallocated, meaning that all the required data
points for the retention values are all written out in 0's so the files
don't explode later on as they are written to. This means that simply
changing the values in storage-schema.conf will not recreate the existing
whisper data files (/opt/graphite/storage/whisper/basename/metric.wsp) so
you can either use whisper-resize.py or resize each table or you can just
delete the data files as I did and when carbon-cache.py is restarted now it
will recreate the files in the correct size.

2. When graphite-client attempts to send an update and the receiver (graphite)
is not listening, graphite-client crashes. (will try:except this)

This is going to be part of the work to graphite-client additions that I do
this weekend. I am still chewing through my options for getting metrics from
the host machine, there are many different stats daemons available:
(statsd, collectd, Diamond, etc.)
