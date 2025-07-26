---
title: "Side Quest #02: VMware Tools in Fusion"
date: 2025-07-17
description: Not all installations are equal
categories: [side-quests]
tags: [virtual-machines, vmware, virtualisation]
image:
  path: "/assets/img/blog/2025-07-17-side-quest-02/side-quest-title-02.png"
  alt: Side Quest 02
---

## SV;DMC (Short Version, Drink More Coffee)

This blog post is about getting VMware Tools to work on an **_Intel_** Mac with the latest version of VMware Fusion.

## Introduction

_Some adventures begin with a stray command, a corrupted ISO, or an innocent ‘what if?’ at 2AM. SideQuests is where we document the unsolicited technical revelations that make life worth scripting. No support tickets in sight. These are the footnotes of your digital epic — the ones more enlightening than the main plot. Loot optional, no XP guaranteed._

## Side Quest

I’ve been using [VMware Fusion](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion) on my Mac for about a decade and a half. I don’t remember which version I bought in on, but I’ve been updating it since. Recently, VMware was bought by Broadcom and [VMware Workstation](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion) (the hypervisor for Windows) and [Fusion](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion) (the hypervisor for Mac) was made available for free; first for personal use and later for everyone. This is a great move since Microsoft is shipping their counterpart, [Hyper-V](https://learn.microsoft.com/en-us/windows-server/virtualization/hyper-v/hyper-v-overview?pivots=windows-server&wt.mc_id=MVP_387063), for free in Windows.

Recently, I downloaded Fusion 13.6.3 and installed it to virtualise macOS Sequoia on my six year old MacBook Pro with an hex-core Intel processor. But I quickly ran into trouble since I couldn’t install VMware Tools in the virtualised machine. I was digging around and couldn’t find the installation files in the application folder on my host.

### Side Quest Attributes

```
+------------------+---------+----------------------------------------+    
| Attribute        | Req Lvl | Notes                                  |    
+------------------+---------+----------------------------------------+    
| 🖥️ Command-Line  | 3       | Some `scp` required                    |    
| 🧠 Intelligence  | 2       | Browsing folder structures             |    
| 🍀 Luck          | 3       | Working network in the virtual machine |    
| 🖱️ Mouse-pointer | 3       | A lot of clicking in this Side Quest   |    
+------------------+---------+----------------------------------------+
```

After reading for a bit on the mighty Internet, I found out that VMware Tools is not present in Fusion 13.6 and above. So, I downloaded version 13.5.2 and could grab it from there with some minor tinkering.

Download Fusion 13.5.2 from here:
https://support.broadcom.com/group/ecx/productfiles?subFamily=VMware%20Fusion&displayGroup=VMware%20Fusion%2013&release=13.5.2&os=&servicePk=520443&language=EN&freeDownloads=true

- Install it
- Go to your `/Applications` folder
- Right-click `VMware Fusion 13` and choose "Show package content"
- Go to `Contents/Library/isoimages/x86_x64/`
- Copy `darwin.iso` and `darwinPre15.iso`
- Move the corresponding to your virtual macOS machine
	- `darwin.iso` for macOS 15 Sequoia and later
	- `darwinPre15.iso` for macOS 14 and earlier
- Install it
- Celebrate!

![Contents folder](/assets/img/blog/2025-07-17-side-quest-02/side-quest-contents-folder.png)
*The contents of the Contents folder in VMware Tools 13.5.2*

You’ll see two macOS related ISO files named `darwin.iso` and `darwinPre15.iso` . As the filenames suggests, the latter is for macOS 14 Sonoma and earlier while the first obviously is for macOS 15 Sequoia and later.

Copy the corresponding ISO file to your virtual machine and run it.

And voilà!

![Install VMware Tools](/assets/img/blog/2025-07-17-side-quest-02/side-quest-install-vmware-tools.png)
*Install VMware Tools in Sequoia in VMware Fusion 13.6.3*

### 📦 Loot and XP

- 💿 `Darwin.iso`
- 🧙🏻 +1 Confidence in Virtualisation
- 📂 +1 Agility in Filesystem Navigation

You feel content after grabbing content from the Contents folder… Yeah, sorry. And in the distance you’re looking for signs for another _Side Quest_.

## 🧘🏼‍♀️ Closing Reflections

While waiting for VMware, or Broadcom, to fix a proper VMware Tools add-on for older Intel Mac’s and even newer Silicon Mac’s, I’ve started using [UTM](https://mac.getutm.app/) and can strongly recommend it.
