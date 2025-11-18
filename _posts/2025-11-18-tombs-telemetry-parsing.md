---
title: "Logwatcher's Zenit #08: Tombs, Telemetry & Parsing"
date: 2025-11-18
description: MITRE's New Detection Model Explained, in depth.
categories: [logwatchers-zenit]
tags: [threat-hunting, threat-detection, incident-response, mitre-attack]
image:
  path: "/assets/img/blog/2025-11-18-logwatchers-zenit-08/logwatchers-zenit-title-08.png"
  alt: Logwatcher's Zenit 08
---

## Introduction
*At the summit of signal and noise lies the Logwatcher’s Ze... eh, a pyramid? The latest initiative from MITRE’s CTID is “Summiting the Pyramid” which invites us to rethink how detections are developed, refined, and scaled. As Logwatchers, we know that excavation requires both a map and a mindset. So, helmet on and grab a flashlight. We're the raiders the lost log. Oh wait, don't forget the coffee.*


## Plotting the Path
In the [Logwatcher's Zenit #06](https://threathunter-chronicles.com/blog/logwatchers-zenit/summiting-the-pyramid.html) post, we climbed up the pyramid to get familiar with MITRE's CITD, *Center For Threat-Informed Defeense* (again, with the non-British spelling; my remark). But this time, we're taking a stroll deep inside the pyramid instead.
I was about to name this blogpost something with *"Deep-Dive"*, but that'd just be silly since it's a pyramid and not a sea, or ocean, of logs.
So, philosophically, how do you deep-dive a tall building? I thought that we could use the analogy of just going deep *into* the pyramid, like archeologists.
And since we're working with MITRE who are famous for the TTPs, I came up with *"Tombs, Telemetry & Parsing"*. Let's do it, Laura Croft style!

## Pyramid of Pain + Robustness
- STP (Summiting the Pyramid) builds on David Bianco’s *Pyramid of Pain*, emphasising that detecting higher-level adversary behaviour (TTPs) causes more pain (cost/effort) for attackers, while low-level IOCs (hashes, IPs) are trivial to evade.
- STP quantifies robustness, which means how hard it is for an adversary to evade a given analytic or detection, shifting defenders from brittle IOCs to behaviour-focused detections. I've even heard a formula for this some years ago. It was something like, "for every $10,000 you pay it'll be 10x harder for the attacker". Not sure if it's still true.

## The Robustness Dimensions
Robustness is measured in two dimensions; Observable and Event/Sensor Robustness. 

I spoke about this together with a colleague at the [Truesec Cybersecurity Summit 2025](https://www.truesec.com/cybersecurity-summit) this year (that's in 2025 for any time travellers reading this post at a later stage). We need to write robust detections and move away from IOCs that are easy to change and manipulate.

When you start to think about its, all of this is actually super easy, *"barely an inconvenience"*. The higher we climb, the better the detection is.

### Observable Robustness
Data Point Stability:
- Ephemeral (easily changed, like file names/IPs/hashes) are low robustness.
- Persistent, contextual observables (like system-wide behaviours) rank higher.

This is also where *sliding window* and *kill chain* comes into play. By just looking at a file name or an IP address is a very narrow window and very easy to evade. Just rename the file and you're done. If we instead start looking at the behaviour, for example if `outlook.exe` starts `msword.exe` which in turn starts a PowerShell script, which in turn downloads a file. That would be a lot harder to evade since it's focusing on the output of the processes instead of the names, or *where* they connect. You see where we are going with this, right? Focus on the *result* instead of the *what*.

### Event / Sensor Robustness
Process Robustness:
- Lower-tier events (user process logs) are easier to bypass.
- Higher-tier sensors (like kernel/hardware) mean harder evasion.

Every EDR and/or XDR agent can be evaded. That's the truth. I'm not saying it's easy to do it, but it can be done and I know threat actors are activily doing it. You have to assume they have got their hands on the latest versions of the major brands' EDR solutions and are actively practicing to get around them. Our job is to find them before they succeed.

### The Levels
Talking about robustness, there are five different levels. According to the *Summiting the Pyramid*, they are:

1. Ephemeral
This is the most trivial level, the easiest to change. This is where we find hash values, file names, IP address et al. Thing that are short-lived and easy to change from an attackers point of view.

2. Core to Adversary-Brought Tool or Outside Boundary
Like the name suggests, this is the level where the attacker has brought their own tools. It can be everything from well-known attacker tools to their own applications. The important thing is that these are not LOLBINs.

3. Core to Pre-Exsisting Tools or Inside Boundary
This level is a bit interesting since some observables that might seem to have Level 1 properties can still be classified as Level 3. File names, for example, that we've classified as a Level 1 can have a Level 3 classification if it's critical for it's function. In other words; rename the file and the program breaks. Commandline arguments are considered to be Level 3.

4. Core to Some Implementations of (Sub-)Technique
Let's say an adversary uses a specific technique, they will inevitably produce those signals unless they change the technique’s implementation fundamentally, and we know they won't. Because multiple implementations share these *low-variance* behaviours we can build strong analytics around them.

5. Core to Sub-Technique or Technique
The highest level. MITRE says *"an essential part of any implementation of the behavior"*. Here we are focusing solely on the behaviour to find the malicious activity. This is the level we should always aim to reach, but don't feel gutted if your detection can't reach this goal. It can still be a great and valuable detection.


## The D³ Model
A [Detection Decomposition Diagram (D³)](https://center-for-threat-informed-defense.github.io/summiting-the-pyramid/detection-diagram/) is a visual method to pinpoint the most reliable observables for detecting malicious technique implementations while minimizing false positives. And fewer false positives means more time for more valuable things. Like coffee ☕️

In short, it's a tool that helps you with the following:
- Adversary goal / tactic
- Concrete malicious behaviours
- Required telemetry
- Detection rules / hunting queries
- Likely benign causes / FP signatures
- Enrichments / pivot points
- Mitigation & response playbook notes

In practicallity, you use D³ early in the detection design to find spanning sets of observables, signals that appear across many variants, then refine by adding specificity and exclusions to balance robustness and accuracy as I wrote above in *Observable Robustness* above.


## A, U and K
We're dividing detections into three main categories; Application, User-Mode and Kernel-Mode. There are two more categories but they're only used for network traffic analysis; Header Visibility and Payload Visibility.

**(A) Application** are observables associated with the use of applications available to defenders before adversary use and difficult for the adversary to modify.
**(U) User-Mode** are observables associatesd with user-mode activity in the OS.
**(K) Kernel-Mode** are directly interfacing with the ring 0 in the OS. Microsoft defines this as the kernel *“implements the core functionality that everything else in the operating system depends upon”*.

It's going to be impossible to reach a robustness of "K5" for all your detections, but just be aware of this and always try to strive to reach the highest possible level.


## STPv3 Table
Here's a table that you can use when you're classifying the robustness of your detections:

| Level   | (A) Application | (U) User-Mode | (K) Kernel-Mode |
| ------- | --------------- | ------------- | --------------- |
| Level 5 |                 |               |                 |
| Level 4 |                 |               |                 |
| Level 3 |                 |               |                 |
| Level 2 |                 |               |                 |
| Level 1 |                 |               |                 |

Just because "K5" is the best doesn't mean that "U4" is a bad and useless detection robuestness. Work with what you've got and just climb as high as you can even if you don't reach the top.


## So, Why You Should Care?
You're here to catch threat actors, aren't you? They're not downloading Mimikatz any longer. It's too noisy and easy to detect, so they are heavily working with the applications that are already on your system; this is what we like to call LOLBINs, or Living Off the Land Binaries. By following the STP model and way of thinking, you'll be able to write more robust detections that I guarantee will find more **true positive** alerts for you to analyse and investigate. Those matter, and will make a difference.

This model also encourages collaboration between teams and will also promote consistency via shared tools and standards. Perhaps it's time to look at a MISP if you don't already have one?

## Further Reading
If you want to read more, I've gathered some good links below.

- [Summiting the Pyramid: Overview](https://center-for-threat-informed-defense.github.io/summiting-the-pyramid/overview/)
- [SANS: Pyramid of Pain](https://www.sans.org/tools/the-pyramid-of-pain)
- [TryHackMe: Pyramid of Pain](https://tryhackme.com/room/pyramidofpainax)


## Closing Notes
Huge thanks for my colleague, Nicklas, whom I shared the stage with during the [Truesec Cybersecurity Summit](https://www.truesec.com/cybersecurity-summit) tour. Couldn't have down the session without him, and wouldn't have been able to write this post either.

Thanks for reading all the way here.
