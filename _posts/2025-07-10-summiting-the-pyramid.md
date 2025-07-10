---
title: "Logwatcher's Zenit #06: Summiting the Pyramid"
date: 2025-07-10
description: 
categories: [Logwatcher's Zenit]
tags: [threat hunting, threat detection, incident response, mitre attack]
image:
  path: "/assets/img/blog/2025-07-10-logwatchers-zenit-06/logwatchers-zenit-title-06.png"
  alt: Logwatcher's Zenit 06
---

#### Introduction

*At the summit of signal and noise lies the Logwatcher’s Ze... eh, a pyramid—layered, daunting, and full of promise?*
The latest initiative from MITRE’s CTID, *“Summiting the Pyramid”*, invites us to rethink how detections are developed, refined, and scaled. As Logwatchers, we know that climbing requires both a map and a mindset. So, boots on and safety line attached. Let’s ascend. Oh Wait, don't forget the coffee.

#### Background

A colleague of mine came back from the [37th annual FIRST](https://www.first.org/conference/2025/), this year in Copenhagen, Denmark. FIRST is *Forum of Incident Response and Security Teams* -- a conference where that brings together computer security incident response teams (CSIRTs) from government, commercial, and educational sectors. If you've never visited any of these conferences you should definitely go. I can't recommend it well enough.

One of the sessions was about [MITRE CTID](https://ctid.mitre.org/)'s new model; *"Summiting the Pyramid"*. According to him, it was the best session too. This really piqued my interest so I've done some reading and digging. By the way, CTID stand for *"Center for Threat-Informed Defense"* (with American spelling, my remark).

With no further ado, let's break down MITRE's project to see what's it all about.

---
### 1: MITRE’s New North Star

*“Summiting the Pyramid”* is a model for building layered, progressive detections. The base of the pyramid begins with data and progresses through layers of abstraction and enrichment until you reach the peak, or the summit: high-confidence, threat-informed analytics.

Here's a link to their project page:
🔗 [MITRE CTID Project Page](https://ctid.mitre.org/projects/summiting-the-pyramid/)

At its core, the model encourages:

- Rigorous documentation of detection logic
- Repeatability through modular templates
- Transparency and collaboration via open-source tooling

It’s the difference between knowing there’s a mountain, and having a trail map that others can follow (or improve).

---
### 2: The Pyramid 

Let’s break down the pyramid in hiking terms:

- **Base Camp – Raw Data:** This is our telemetry: process creation logs, DNS queries, PowerShell events. It’s noisy, unstructured, and found everywhere.

- **Mid-Tier – Behavioural Analysis & Enrichment:** Here you start correlating events, applying heuristics, adding threat intelligence, and maybe sprinkling in some machine learning fairy dust on top of it. It's where things get interesting—but also slippery.

- **The Summit – Validated Detections Aligned to TTPs:** At the top, detections are tied to tactics, techniques, and procedures (TTPs). They are tested, verified, and operationalised. They’re not just "good ideas"—they're proven footholds.

This model complements the [Detection Maturity Level (DML)](https://ryanstillions.blogspot.com/2014/04/the-dml-model_21.html) model by Ryan Stillions, but adds a more structured, almost narrative arc to the development process.

---
### 3: KQL + Summit = ❤️

You didn't think that I'd write a post without any KQL, did you? Let’s apply the model with an example in [Microsoft Sentinel](https://learn.microsoft.com/en-us/azure/sentinel/overview?tabs=defender-portal&?wt.mc_id=MVP_387063), still using the hiking terms, so you'll see how you should think about threat hunting and threat detection.

**Scenario:** Suspicious use of `rundll32.exe` to load a potentially malicious DLL.

- **Base:**
```kql
DeviceProcessEvents
| where FileName == "rundll32.exe"
```
*(Try the Base query to see what I'm talking about because you can't break anything. Hello noise!)*


- **Mid-Tier:**
```kql
DeviceProcessEvents
| where FileName == "rundll32.exe"
| where ProcessCommandLine has_any (".dll", "http", "javascript")
| extend suspicious_score = iif(ProcessCommandLine has "http", 1, 0)
```


- **Summit:**
```kql
DeviceProcessEvents
| where FileName == "rundll32.exe"
| where ProcessCommandLine has_any (".dll", "http")
| join kind=inner (
    ThreatIntelligenceIndicator
    | where Description has "rundll32"
) on $left.InitiatingProcessFileName == $right.ThreatIntelligenceIndicator
| project Timestamp, DeviceName, ProcessCommandLine, Description
```

The same log source becomes more meaningful the higher you climb, because we're looking at it in a smarter way. The information has always been there, as signals hidden in the noise. We just need to understand how we should handle it, filter out some noise, interpret it, twist it and make it make sense.

---
### 4: MITRE’s Framework in Action

MITRE provides a [Detection Development Framework](https://github.com/center-for-threat-informed-defense/detection-development-framework) that includes:

- YAML templates for documenting detections
- Python tools for processing and validating them
- Examples and mapping to MITRE ATT&CK

*-"Am I back in school?"*, I can hear you think. This isn't just academic. The goal is to create **repeatable, modular, defensible** detections that teams can share and adapt. You're doing more now so you can do less later and use that extra time to do something important, like squinting at another timeline looking for clues. Or drinking coffee. *Slurp. Yum.*

---
### 5: Are We There Yet?

IF you're a parent, you heard that line before. Not every alert leads to an adversary, but every investigation refines the path for those who follow. The art of detection is an iterative ascent. Sometimes we reach the summit; sometimes we map a dead-end so others don’t follow it. In either case, we add to the collective map. And this is why I ask you to leave your assumptions at home and not come alone.

Until next time. Stay sharp, Logwatchers. There are more timelines ahead to squint at.

---
### 📚 Further Reading:

- [MITRE CTID Project Page](https://ctid.mitre.org/projects/summiting-the-pyramid/)
- [Summiting the Pyramid, v3](https://center-for-threat-informed-defense.github.io/summiting-the-pyramid/)
- [Detection Development Framework GitHub](https://github.com/center-for-threat-informed-defense/detection-development-framework)
- [DML: Detection Maturity Level Model](https://ryanstillions.blogspot.com/2014/04/the-dml-model_21.html)
