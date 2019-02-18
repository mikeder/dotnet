---
title: Roland Jupiter 6 Troubleshooting
date: 2016-11-29 16:10:18
updated: 2016-11-29 11:10:18
categories: ["Archive"]
---

CPU acting very erratic, front panel sometimes doesn't boot, other times will go completly haywire (See Video)
Initially thought PSU ripple due to age of caps and reported behavior of CPU when the PSU isn't clean.

Confirmed PSU ripple not the cause, after confirming correct scope settings on FB group.

Started suspecting CPU itself was bad, asked around for replacements, as well as eprom.

Europa is "taking a hiatus" as of 11/18/16, no good

CPU can be replaced with any P8031/8051 MCU, when pin 31 is grounded the CPU loads its program from eprom.
When not grounded, it attempts to load its program from internal ROM (Europa CPU)

MCU P80C31 contains a crystal and can be used to avoid undoing the Pin 18/19 clock mod.

During troubleshooting I found that occasionally 2 voices will still work, albiet glitchy at times. So I unplugged all
of the connectors on the module and cpu boards and cleaned their pins with deoxit. This improved the fault quite a bit.


...to be continued...