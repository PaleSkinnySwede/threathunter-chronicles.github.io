---
title: "Logwatcher's Zenit #01: VS Code for Analysts, part 1"
date: "2025-05-29"
description: Here's how to let your keyboard to the hunting.
categories: [logwatchers-zenit]
tags: [cybersecurity, threat-hunting, incident-response, visualstudio-code, key-commands]
image:
  path: "/assets/img/blog/2025-05-29-logwatchers-zenit-01/logwatchers-zenit-title-01.png"
  alt: Logwatcher's Zenit 01
---

_Here’s how to let your keyboard do the hunting._

## Introduction

At the summit of signal and noise lies the _Logwatcher’s Zenit_. It's a quiet place for analysts who squint at timestamps and whisper to correlation engines. This category explores log analysis, data parsing, and threat hunting with a touch of [KQL](https://learn.microsoft.com/en-us/kusto/query/?view=microsoft-fabric&wt.mc_id=MVP_387063), a dash of [XDR](https://www.microsoft.com/sv-se/security/business/siem-and-xdr/microsoft-defender-xdr/?wt.mc_id=MVP_387063), and the occasional existential crisis about why that one alert keeps firing every Friday afternoon 5 minutes before you’re about to clock out.

Expect practical queries, musings on telemetry, and maybe even a few moments of enlightenment between the joins and the let-statements. Bring your coffee. Leave your assumptions at home and come alone.

# VS Code for Analysts, part 1

Before we can start doing any analysis, write [KQL](https://learn.microsoft.com/en-us/kusto/query/?view=microsoft-fabric&wt.mc_id=MVP_387063) or dive deep into the wonderful world of threat hunting, we need a place to be. This is where [Visual Studio Code](https://code.visualstudio.com/) really shines. It’s my favourite editor and like with everything else; if you learn it well, it’ll help you to stay productive.

# ⏱️ Why Shortcuts Matter in Threat Analysis

_When milliseconds matter, keystrokes win._

Threat hunting and log analysis often require you to bounce between files, tweak queries, and inspect large data sets quickly. Every time your hand leaves the keyboard to touch the mouse, you lose momentum and in our line of work, flow is everything.

Imagine if you could move a couple of lines up or down, select some lines and sort them, all without letting your fingers leave the keyboard. Well, you can! [VS Code](https://code.visualstudio.com/) is a powerhouse for log analysis, scripting, and threat hunting — but only if you know how to wield it like a true professional. In this post I’ll give you the shortcut keys that I use the most and almost are willing to call “life-savers”.

Got your coffee? Tu es prête?  
_(I’m learning French in DuoLingo — but this will be an English blog)._

On y va! 😉

---
# ⌨️ My Top Shortcuts for Security Analysts (Mac / Windows)

Here’s a list of key commands and combinations that make a real difference when parsing logs, reviewing detections, or writing KQL queries.

---
# Rapid Navigation

**Quick file search**  
`Cmd + P` / `Ctrl + P` Instantly open recent files by name. Great when hopping between `.kql`, `.json`, `.ps1`, and `.md` notes.

**Go to symbol in file**  
`Cmd + Shift + O` / `Ctrl + Shift + O` Jump to a function, query block, or section header.

**Go to definition**  
`F12` Peek or jump to a function/variable definition — useful when parsing Python threat tooling or custom PowerShell modules.

---
# Multi-File Intelligence

**Global search across files**  
`Cmd + Shift + F` / `Ctrl + Shift + F` Perfect when tracing IOCs or correlating detection logic.

**Search and replace in selection**  
`Cmd + F` → `Opt + Cmd + Enter` / `Ctrl + F` → `Alt + Ctrl + Enter` Helpful for bulk editing IPs, file hashes, or rule attributes.

---
# Code Manipulation & Querying

**Move line up/down**  
`Option + ↑ / ↓` / `Alt + ↑ / ↓` Tidy up detection rules or sort logic blocks.

**Duplicate line**  
`Shift + Option + ↓` / `Shift + Alt + ↓` Great for template reuse in KQL and PowerShell.

Sorting lines  
`Shift + Cmd + P` / `Shift + Ctrl + P` → type “sort lines”  
Choose “Sort Lines Ascending” or “Sort Lines Descending”.

**Comment/uncomment selection**  
`Cmd + /` / `Ctrl + /` Quickly toggle comments in scripts.

---
# Text-TV Power

**Toggle terminal  
**`` Ctrl + ` `` (Same for both macOS and Windows)  
Jump in and out of the integrated terminal without leaving VS Code — perfect for running Sentinel APIs, PowerShell scripts, or CLI tools.

**Toggle sidebar**  
`Cmd + B` / `Ctrl + B`Keep the interface minimal when deep in a trace.

GitHub Copilot chat  
`Ctrl + Cmd + I` / `Ctrl + Alt + I`  
Opens the GitHub Copilot chat sidebar.

---
# Bonus: Keyboard Shortcuts Reference

**View all commands**  
`Cmd + Shift + P` / `Ctrl + Shift + P` → type “Keyboard Shortcuts”

You can remap and explore more here to build your perfect hunting cockpit in VS Code.

Comment below and tell me your own favourite key commands and combinations. I’d love to add few more to my muscle memory to speed things up.
