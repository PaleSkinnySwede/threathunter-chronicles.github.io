---
title: "SideQuest #01: How To Virtualise Sequoia"
date: 2025-06-02
description: Converting Install macOS Sequoia.app to an ISO file
categories: [side-quests]
tags: [macos, sequoia, virtualisation, tips-n-tricks, operating-systems]
image:
  path: "/assets/img/blog/2025-06-02-side-quest-01/side-quest-title-01.png"
  alt: Side Quest 01
---

_Converting_ `_Install macOS Sequoia.app_` _to an ISO file_

## Introduction

_Some adventures begin with a stray command, a corrupted ISO, or an innocent ‘what if?’ at 2AM. Side Quests is where we document the glorious tangents: the odd tools, offbeat projects, and unsolicited technical revelations that make life worth scripting. No XP guaranteed, but an adventure more enlightening than the main plot. Loot optional._

# Let the Side Quest Begin

In this first episode in the _Side Quest_ category, I’m diving into how I managed to install macOS 15 Sequoia in VMware Fusion 13 on my six year old Intel MacBook Pro.

Life is full of side quests. Make sure to do them all.

## Prerequisites

You’re going to need the `sudo` password for the Mac and you’re going to need almost 60GB of free space before you begin.

## Side Quest Attributes

```
+------------------+---------+-----------------------------------------+  
| Attribute        | Req Lvl | Notes                                   |  
+------------------+---------+-----------------------------------------+  
| 🖥️ Command-Line  | 3       | Basic `hdiutil` and Terminal-fu         |  
| 🧠 Intelligence  | 4       | Interpreting obscure error messages     |  
| 🍀 Luck          | 4       | Disk space and cursed `.cdr` extensions |  
| 🔧 Craftsmanship | 3       | Precision disk imagesmithing            |  
+------------------+---------+-----------------------------------------+
```

## Loot and XP

💿 Sequoia.iso  
🖥️ +1 Proficiency in Command-Line  
🧙‍♂️ +1 Confidence in Virtualisation

## Download macOS Sequoia

Open the App Store app and search for the OS version you want to download. Click “Get” and then “Download” and it should start downloading. Now, depending on your Internet speed — this is a good time to drink more coffee ☕️. This is a 17GB download.

![](/assets/img/blog/2025-06-02-sidequest-01/ThreatHunter%20Chronicles%20Download%20macOS%20Sequoia.png)
_App Store where you can download macOS Sequoia_

## Create the ISO

Now it’s time to create the ISO file from the downloaded file.  
When downloaded the file will end up as an application called `Install macOS Sequoia` in your`/Applications` folder.

{: .prompt-info }
> All the commands below are also available in my GitHub repository here:  
> [https://github.com/PaleSkinnySwede/ThreatHunter-Chronicles/tree/main/SideQuests/01%20-%20How%20To%20Virtualise%20Sequoia](https://github.com/PaleSkinnySwede/ThreatHunter-Chronicles/tree/main/SideQuests/01%20-%20How%20To%20Virtualise%20Sequoia)

The first step is to create a volume which we can write the installation files to. You do this by opening the Terminal and type:

`hdiutil create -o /tmp/sequoia -size 20480m -volname Sequoia -layout SPUD -fs HFS+J`

This will create a 20GB volume named “Sequoia” with the journaling version of HFS, unless you roll a 2 in the _Random Encounter_ — then the file will be 2GB. Make sure you type `20480m` .

When done, it’s time to mount it to the file system. Still in the Terminal, type this:

`hdiutil attach /tmp/Sequoia.dmg -mountpoint /Volumes/Sequoia`

Now, let’s create the install media. Here’s the command line to do that:

`sudo /Applications/Install\ macOS\ Sequoia.app/Contents/Resources/createinstallmedia --volume /Volumes/Sequoia`

Before we convert it, we need to detach it:

`hdiutil detach /Volumes/Install\ macOS\ Sequoia`

And now, let’s make an ISO file. First, convert it to a CDR file using `hdiutil` and place it on the Desktop so it’s easy to find:

`hdiutil convert /tmp/Sequoia.dmg -format UDTO -o ~/Desktop/Sequoia.cdr`

The Desktop is the perfect download folder. Trust me on this one. It’s the place where a lot of sane people are actually saving their files.

> Apple’s command-line tools are like jazz musicians — they _almost_ follow the rules, but then throw in a surprise extension just to keep you on your toes.

The `hdiutil` is one of those tools that suffer a bit from _Apple-ism_ and it will hard code `.cdr`as the file extension. If you tried to name the file `Sequoia.iso` in the command above, it will now be called `Sequoia.iso.cdr`. Let’s change the filename from `.cdr` to `.iso` by typing the following:

`mv ~/Desktop/Sequoia.cdr ~/Desktop/Sequoia.iso`

Now you’ve got a fine and fresh `Sequoia.iso` file on the Desktop that you can use in VMware Fusion or any other hypervisor application on your Mac. Have fun!

## Cleaning up

If you already have Sequoia, or don’t want to install it, on your Mac you can go ahead an delete the `Install macOS Sequoia.app` from the `/Application` folder and don’t forget to also delete the `Sequoia.dmg` in your `/tmp` folder. This will return 37 precious GB of free space in your inventory for other loot you might come across in other _SideQuests_.

## 🎲 Random Encounter List (roll d4)

1. ”No operating system found.”
2. Volume ends up being 2GB instead of 20GB.
3. The VM boots into Recovery mode.
4. Finder crashes mid-process. You question reality.

After you’ve finished creating the mighty `Sequoia.iso` ready to be used when needed, you’re strolling along a path through the woods. You see a wizard-looking tall woman approaching you. She stops in front of you and whispers; _“You will find the tools in the past. Make sure to get them.”_ She then disappears like smoke that dissolves in to thin air. You’re thinking to yourself; _“Is this another Side Quest?”._
