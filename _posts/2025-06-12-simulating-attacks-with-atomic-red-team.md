---
title: "Logwatcher's Zenit #02: Simulating Attacks with Atomic Red Team"
date: 2025-06-12
description: How to Validate Your Detection Logic Without Summoning a Real Threat Actor
categories: [logwatchers-zenit]
tags: [threat-hunting, threat-detection, log-analysis, cybersecurity]
image:
  path: "/assets/img/blog/2025-06-12-logwatchers-zenit-02/logwatchers-zenit-title-02.png"
  alt: Logwatcher's Zenit 02
---

_How to Validate Your Detection Logic Without Summoning a Real Threat Actor_

> “The map is not the territory. But a map sure helps when you’re lost in a forest of false positives.”

## Introduction

_At the summit of signal and noise lies the Logwatcher’s Zenit — a quiet place for analysts who squint at timestamps and whisper to correlation engines. Bring your coffee, leave your assumptions at home, and fire up your favourite text editor._

At some point in your detection engineering journey, you’ll stare at a rule you’ve written and wonder:  
_“Does this actually work? Or have I just built an elegant monument to wishful thinking?”_

Welcome to the strange joy of adversary simulation.  
Not red teaming. Not _[insert any colour]_ teaming, actually.  
Not breaking into boxes or tiptoeing past EDRs.  
Just you, your telemetry, and a library of small, well-documented threats that exist for one purpose:  
**To test your ability to see.**

---
# 🧪 What Is Atomic Red Team?

[Atomic Red Team](https://github.com/redcanaryco/atomic-red-team) is an open-source project by [Red Canary](https://redcanary.com/), designed to test your detection coverage against real-world adversary techniques. Each “atomic” test maps to a specific [MITRE ATT&CK](https://attack.mitre.org/) technique and does one thing but does it really well.

They’re simple actions like creating a scheduled task, spawning a suspicious PowerShell command, or dropping an encoded payload to disk. Think of them as lab rats in your SIEM maze: small, twitchy, and incredibly useful for understanding how your environment reacts to malicious behaviour.

---
# Why You Should Care

There are many reasons to run simulations like this:

- ✅ Validate that your detection actually fires
- 🧪 Generate test telemetry for writing or tuning rules
- 🧠 Train analysts to interpret subtle signals
- 🔄 Catch regressions after content or config changes

And let’s be honest, sometimes it’s just fun to throw a known rock into the pond and watch the ripples.

---
# ⚙️ Setting It Up

# Option 1: Classic Setup (Manual)

This is great for Linux and macOS fans who like control and don’t mind a bit of… uhm… let’s call it “friction”.

1. Clone this [repo](https://github.com/redcanaryco/atomic-red-team) to `~/AtomicRedTeam`
2. Run tests manually using the provided scripts
3. Manage dependencies yourself and earn your detection badge of honour. This isn’t a _SideQuest_, but there are still XPs to earn.

![](/assets/img/blog/2025-06-12-logwatchers-zenit-02/ThreatHunter%20Chronicles%20Detection%20Badge.png)

Logwatcher’s Detection Badge of Honour

# Option 2: PowerShell Module

Recommended on Windows machines, but works just fine on macOS too if you first install [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos?view=powershell-7.5#installation-via-direct-download/?wt.mc_id=MVP_387063). It’s especially geeky together with `zsh` in the macOS Terminal.

- Open PowerShell as admin
- Run:

```powershell
Install-Module -Name Invoke-AtomicRedTeam -Force
```

- Initialize the tests:

```powershell
Invoke-AtomicTest T1059.001 -ShowDetails
```

- Run a test:

```powershell
Invoke-AtomicTest T1059.001 -TestNumbers 1
```

This method automatically pulls in dependencies, runs tests cleanly, and logs beautifully, perfect for pairing with Sysmon, Defender, or Sentinel ingestion.

# Option 3: Atomic-Operator (Cross-Platform CLI)

If PowerShell isn’t your style, [Atomic-Operator](https://github.com/redcanaryco/atomic-operator) gives you a language-agnostic way to launch tests. It’s new. It’s shiny. But still evolving, which means: “not quite ready for prime time just yet”.

---
# 🧭 Your First Test

Let’s say you want to test **PowerShell Execution** (T1059.001).

- Search for available tests:

```powershell
Search-AtomicTests T1059.001
```

- Review the test with:

```powershell
Invoke-AtomicTest T1059.001 -TestNumbers 1 -ShowDetails
```

- Then fire it off and watch your logs come alive.

![](/assets/img/blog/2025-06-12-logwatchers-zenit-02/frankenstein-its-alive.gif)

It’s alive!

{: .prompt-tip }
> **_Pro tip:_** Always preview tests before running them. Some write to disk, touch the registry, or run as scheduled tasks.

---
# 🔍 What to Look For

Depending on your logging setup, the test will generate telemetry like:

- **Event ID 4104** (ScriptBlockLogging)
- **Sysmon Event ID 1** (Process Create)
- **Microsoft Defender** detections
- **DeviceProcessEvents** in Microsoft Sentinel

☕️ Keep your KQL handy. Watch your logs in tail mode. And yes, **have coffee ready**. Detection is as much patience as it is parsing. And drinking coffee.

---
# 🧠 Hunting the Simulated Threat

This is where things get real.

You ran the test. Now hunt it like it’s a true adversary:

- Use KQL to find the process tree
- Follow command lines, parent/child relationships, or network calls
- Test your existing analytics. Do they fire?
- If not, why not?

The last bullet is the most important question in detection engineering, apart from _“when is the coffee ready?”_

Here’s a _super simple_ example to find PowerShell executions:

```kql
DeviceProcessEvents  
| where FileName =~ "powershell.exe"  
| where ProcessCommandLine has_any ("-EncodedCommand", "Invoke-Expression", "IEX")
```

Want to up the difficulty? Hide the test name from yourself. Pretend it’s real. And chase it through your logs like it matters, because that’s how you train your instincts. Or ask a colleague to fire off a few different tests without telling you which they are. Fun times ahead!

---
# 🔁 Making It Repeatable

Want to run tests on a schedule? Tie them into a CI/CD pipeline? Feed the results into a coverage dashboard?

You absolutely can.

- Run specific technique IDs regularly (e.g., T1547.001 weekly to test persistence detections)
- Create playbooks that launch tests and validate detections
- Map ART test results to [Sentinel Workbooks](https://github.com/Azure/Azure-Sentinel-Workbooks)

This turns simulation from an _event_ into a _practice_.

---
# ⚠️ Limitations and Caveats

Let’s be clear though. While the Atomic Red Team is a good way of testing individual detections or surprise a colleague with a weird alert when they least expect it, we still have to consider a few things:

- These are **simulations**, not real attacks
- They often don’t bypass EDRs or chain with lateral movement
- Some tests won’t work on modern Windows builds due to mitigations
- **Always test in a safe, non-production lab**

Like a friend use to say: _“Every company has a test environment. At some companies it’s different from the production environment.”_

Think of ART like a crash test dummy: it’s not trying to fool the car, but it’s helping you build the seatbelt and airbags.

---
# 🧘 Closing Thoughts

Running an Atomic Red Team test is like striking a bell in your environment and listening for echoes. Do you hear them? Do they show up where you expected? Do they hide behind the noise?

Detection is not about having the perfect rule.  
It’s about knowing what _should_ happen — so you can spot when it doesn’t.

And in that space, between signal and silence, between test and telemetry, lives the Logwatcher. Quiet. Focused. Aware. Squinting at timelines. Drinking coffee.

---
# 📎 Quick Links

- [Atomic Red Team GitHub](https://github.com/redcanaryco/atomic-red-team)
- [Invoke-AtomicRedTeam](https://github.com/redcanaryco/invoke-atomicredteam)
- [AtomicTestHarnesses](https://github.com/redcanaryco/AtomicTestHarnesses)
- [MITRE ATT&CK Navigator](https://mitre-attack.github.io/attack-navigator/)
