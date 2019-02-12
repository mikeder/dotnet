---
title: "Dell Power Eval"
date: 2015-01-04T01:57:21-05:00
categories: ["Archive"]
tags:
- dell
- homelab
- power
- virtualization
---

#### Factoring price of running servers

The new battery back-up that I have my servers connected to reports ~0.386kW
with both servers running. With this number I can calculate the energy cost to
keep these servers running. Looking at my BGE bill there is quite a list of
charges, fees, and taxes multiplied by my usage measure in kWh. Here is what my
latest bill looks like:

```
BGE Elec Supply                 682 kWh x .0857500    58.48

BGE Electric Delivery Service
Customer Charge                                       7.50
EmPower MD Chg                  682 kWh x .0041100    2.80
Distribution Chg                660 kWh x .0344000   22.70
                                 22 kWh x .0354100     .78
RSP Chg/Misc Cr                 682 kWh x .0033600    2.29
Dmd Res Chg/Cr                  682 kWh x .0002900     .20
ERI Initiative Chg              682 kWh x .0000900     .06

State / Local Taxes & Surcharges
MD Universal Svc Prog                                  .36
Envir Srchg                     682 kWh x .0001500     .10
Franchise Tax                   682 kWh x .0006200     .42
Local Tax                       682 kWh x .0077900    5.31

Total price per kWh                       .1719700
Total BGE Electric Amount                          $101.00
```

To figure out how much the servers cost to run I need to figure out how many
kWh they use per day.

```
# E(kWh) = P(kW) x t(hr)
E = 0.386 x 24 = 9.264        # kWh per day
9.264 x .17197 = 1.59313008   # $ per day
1.59313008 x 31 = 49.38703248 # $ per month
```

So about $50/month worth of electricity, assuming I keep both servers running
24/7, which I rarely do. My second server, TS2, only runs a Space-Engineers
dedicated server when I feel like playing so it isn't on all the time. This
cost is certainly manageable compared to the cost of paying a hosting company
for all of the services that I manage at home. A Space-Engineers dedicated
server, albeit better server specs than my own, can run up to $200/month. A
small VPS for running a LAMP stack for the website can be had for cheap but at
home I can run ESXi and as many VM's as my server can handle for a lot less.

The battery backup has a USB out that can be connected to a computer so that in
the event of power loss the computer(s) can be shut down safely. I plan on
using the linux tool that is available on the CyberPower website and building a
shutdown script around it to run on my RaspberryPi. The RPi can then send IPMI
commands to the Dell servers to shutdown if needed and then start back up when
normal power returns. I plan on doing some work on this script today and will
probably make a new entry once i've made some progress.
