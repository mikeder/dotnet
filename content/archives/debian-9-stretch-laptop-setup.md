---
title: Debian 9 (Stretch) Laptop Setup
date: 2017-10-13 02:15:24
updated: 2017-10-12 22:20:42
categories: ["Archive"]
---

Setting up an old Acer Aspire One 722-0473

Edit `/etc/apt/sources.list` - add contrib and non-free packages

    deb http://httpredir.debian.org/debian/ stretch main contrib non-free

#### Update and install drivers

    apt-get update
    apt-get install firmware-amd-graphics

#### Add touchpad config

Edit `/usr/share/X11/xorg.conf.d/50-touchpad.conf` - add below section

    Section "InputClass"
	    Identifier "touchpad catchall"
	    Driver "synaptics"
	    MatchIsTouchpad "on"
	    Option "TapButton1" "1"
	    Option "TapButton1" "3"
     EndSection