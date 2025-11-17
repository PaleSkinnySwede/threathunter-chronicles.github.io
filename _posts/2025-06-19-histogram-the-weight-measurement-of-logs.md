---
title: "Logwatcher's Zenit #03: Histogram, the Weight Measurement of Logs"
date: 2025-06-19
description: Bin it. Chart it. Peek at the peaks.
categories: [logwatchers-zenit]
tags: [threat-hunting, threat-detection, log-analysis, cybersecurity]
image:
  path: "/assets/img/blog/2025-06-19-logwatchers-zenit-03/logwatchers-zenit-title-03.png"
  alt: Logwatcher's Zenit 03
---

_Bin it. Chart it. Peek at the peaks._

![](/assets/img/blog/2025-06-19-logwatchers-zenit-03/ThreatHunter%20Chronicles%20Logwatchers%20Zenit%2003.png)

_At the summit of signal and noise lies the Logwatcher’s Zenit, a quiet place for analysts who squint at timestamps and whisper to correlation engines. Bring your coffee, leave your assumptions at home, and fire up your favourite log parser._

## Introduction

Histograms, the underrated champions of shape and structure. It can really tip the scales of any investigation. While your data might weigh in at petabytes, it’s these humble bins that are _David_ when you’re wrestling logs the size of _Goliath_.

In this post, we explore how histograms in [KQL](https://learn.microsoft.com/en-us/kusto/query/?view=microsoft-fabric&wt.mc_id=MVP_387063) (and beyond) help analysts reveal periodicity, detect anomalies, and catch that beaconing malware that always checks in at _exactly_ 10-minute intervals like it’s punching a cursed time clock or just being an insanely slow drum machine someone forgot to sync, or turn off.

## What _Is_ a Histogram?

A histogram isn’t just a bar chart, it’s a story. A tale of counts over time. A saga of spikes, and silence. When you bin data over time intervals, you begin to see the rhythm of your logs: the heartbeat of systems, the subtle pulse of attackers, the glaring gaps when something suddenly… stops.

Think of it this way: if raw logs are atoms, then a histogram is the periodic table.

Let’s start by looking at some neat examples in [Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/overview?tabs=defender-portal&%3Fwt.mc_id=MVP_387063). Most of them will work perfectly fine in [Microsoft Defender XDR](https://www.microsoft.com/sv-se/security/business/siem-and-xdr/microsoft-defender-xdr/?wt.mc_id=MVP_387063) as well, unless I make a note of it. We don’t want you experience angry error messages. I’ll go through the syntax you need and will follow up with a couple of use cases.

---
## The Basic Spell: `summarize count() by bin(Timestamp, Timespan)`

It’s now time to link up with your inner Histogram Magician. Well, it’s not really magic because magic doesn’t exist. But your colleagues might think it is, so why not get that magic wand after all?

> — “It’s dangerous to go alone. Take this. 🪄”

With great power comes great responsibility, so wave and whisk it wisely and make sure to not knock things over with it. From a magician to another; use your wrist rather than your arm.

To get the `DeviceNetworkEvents` from Microsoft Defender XDR, you need to connect the Microsoft Defender XDR data source in Sentinel. And I assume you know how to do it. Let me know in the comment section. I could turn the whole data connector thingy into a blog post if requested.

Another thing to note when mixing Defender XDR and Sentinel data is that Defender XDR calls an endpoint`DeviceName` while Sentinel calls them `Computer` .

Now we’re ready.

```kql
DeviceLogonEvents  
| where Timestamp > ago(1d)  
| summarize count() by bin(Timestamp, 10m)  
| render timechart
```

This shows how many logon events occurred every 10 minutes. Great for spotting brute force attempts, scripted logons, or just… weirdly regular behaviour that smells like a bot, walks like a bot, and logs on like a bot.

---
## Use Case 1: Spotting Beaconing Behaviour

Attackers love regularity. You know who else does? Histograms.

```kql
DeviceNetworkEvents  
| where Timestamp > ago(1d)  
| where RemoteUrl has "example.com"  
| summarize count() by bin(Timestamp, 5m)  
| render timechart
```

If that line is suspiciously flat across the timeline, congrats: you’ve found a digital metronome. Beaconing C2? Scheduled task gone rogue? Only one way to find out. But first — admire the histogram. They can be such beautiful visuals.

{: .prompt-tip }
> **_Pro Tip:_** When in doubt, look for periodicity. If your logs resemble a Japanese train schedule, someone’s probably up to no good.

---
## Use Case 2: Idle Systems, Active Minds

In 1967, The Tremeloes sang _“Silence is golden”_. But sometimes, silence is actually the anomaly. Silence could be the one thing we didn’t know we were looking for — but with a histogram it became perfectly clear.

Here’s a _Sentinel only_ KQL query using the _Heartbeat_ table and _TimeGenerated_ instead of Defender XDR’s _Timestamp_.

```kql
Heartbeat  
| where TimeGenerated > ago(3d)  
| summarize count() by bin(TimeGenerated, 1h)  
| render timechart
```

Got a host that usually phones home every 5 minutes but suddenly drops off the radar for a few hours? Might be a network glitch. Might be a sleep schedule. Might be _compromise o’clock_.

{: .prompt-info }
> **_Zen Reminder:_** It’s not just about the peaks. The valleys speak too. And valleys means silence. 🧘‍♂️

---
## Bonus: Building Custom Buckets

Who said time is the only dimension? Let’s bucket by another field:

```kql
DeviceEvents  
| where Timestamp > ago(1h)  
| summarize count() by bin(Timestamp, 5m), ActionType  
| render timechart
```

Want to see how many `ProcessCreated` vs `FileDeleted` events happen over time? This will give you a layered view, and if one layer starts growing like mushrooms after rain — it’s time to investigate.

---
## Visual Density vs Visual Clarity

A quick word of caution: don’t over-bin it.

bin(Timestamp, 1s)

Sure, you _can_ bin at one-second intervals. But unless you’re hunting nation-state actors who operate on atomic clocks, that’s just visual noise. Balance is key. Choose your resolution based on your context.

---
# Final Example: Histogram + Join = Love

This query will only work in Sentinel since we’ll utilise the `Heartbeat` table again.

```kql
let SuspiciousHosts =   
    DeviceNetworkEvents  
    | where RemoteUrl endswith ".xyz"  
    | summarize by DeviceName;  
Heartbeat  
| where Computer in (SuspiciousHosts)  
| summarize count() by bin(TimeGenerated, 1h), Computer  
| render timechart
```

Now we’re filtering the heartbeat by a suspicious host list. If they start skipping beats… don’t ignore it.

# 🧘 Conclusion: Read Between the Bins

A histogram is more than just a tool — it’s a lens. One that lets you step back, squint, and _see_.

It won’t solve the case for you. But it’ll show you where the rhythm breaks, where anomalies bloom, and where your attention should wander.

So next time you’re staring at raw logs and feeling like you’re drowning in entropy: bin it! Chart it! Read between the bars or under the lines. Maybe your math teacher was right after all? The area under the curve could perhaps tell a store and be that _Integral_ part of your investigation.

Because in the end, histograms could actually be heavier than kilograms.
