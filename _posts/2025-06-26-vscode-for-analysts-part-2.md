---
title: "Logwatcher's Zenit #04: VS Code for Analysts, part 2"
date: 2025-06-26
description: Order in chaos is what separates a good analyst from a great one.
categories: [logwatchers-zenit]
tags: [threat-hunting, threat-detection, incident-response, log-analysis, visualstudio-code]
image:
  path: "/assets/img/blog/2025-06-26-logwatchers-zenit-04/logwatchers-zenit-title-04.png"
  alt: Logwatcher's Zenit 04
---

_Order in chaos is what separates a great analyst from a good one._

#### Introduction

_At the summit of signal and noise lies the Logwatcher’s Zenit — a quiet place for analysts who squint at timestamps and whisper to correlation engines. Bring your coffee, leave your assumptions at home and make sure your wireless mouse and keyboard are fully charged._

#### Let’s Go

In [the first part](https://threathunter-chronicles.com/blog/logwatchers-zenit/2025-05-29-vscode-for-analysts-part-1.html), we looked at my favourite key commands making Visual Studio Code one of my favourite tools when analysing and dissecting malicious scripts so I can build detections and threat hunting rules.

Today, in part 2, we descend from the peak to wander the plugin bazaar of Visual Studio Code. Not all tools are built for us, but some? Some are forged in the fires of parsing and anomaly hunting.

Here are the extensions I keep close, like a hunter’s blade and a bard’s flask — each one tuned for threat hunters, log sculptors, and cyber-detectives.

---

### 🧠 I. For the Query-Crafting Analyst

These are your incantation enhancers. For when you speak KQL fluently, juggle CSVs, or decorate your comments like post-it notes in a war room. Adding some colour to your hectic investigations is never wrong, so be open-minded to it.

### 🔍 1. Kusto (KQL) Language Support

_Publisher: Microsoft_

This one’s non-negotiable. If you live in the world of Microsoft Sentinel, Defender for Endpoint, or Log Analytics, the **Kusto Language** extension is your compass and spellbook in one.

- Syntax highlighting that actually respects the KQL gods.
- Autocomplete for functions like `parse_json`, `summarize`, `project-away`, and other magic words.
- Linting to gently scold you when you forget a `by` after `summarize`.

🔗 [Install it here](https://marketplace.visualstudio.com/items?itemName=ms-kusto.kusto-language)

### 🌈 2. Rainbow CSV

_Publisher: mechatroner_

When logs masquerade as CSVs but feel more like crossword puzzles, **Rainbow CSV** is your savior. This extension colorizes each column in `.csv`, `.tsv`, and `.psv` files using a distinct hue — instantly improving readability and reducing parsing-induced rage.

Why it belongs in every analyst’s kit:

- Columns are colour-coded, making data easier to scan.
- Supports custom delimiters for those weird `|` or `;`-delimited files vendors keep inventing.
- Detects broken CSV lines (looking at you, rogue newline in column 12).
- Bonus: SQL-like query engine for quick local searches.

If you deal with exports from Sysmon, Microsoft Graph, or that One Weird Excel File™ your customer insists is “log format” — this one’s a no-brainer.

👉 [Rainbow CSV](https://marketplace.visualstudio.com/items?itemName=mechatroner.rainbow-csv)

### 🛠️ 3. Better Comments

_Publisher: Aaron Bond_

Your future self will thank you. This plugin color-codes your comments so you can visually distinguish:

- `// TODO:` (yellow)
- `// HACK:` (red)
- `// NOTE:` (blue)
- `// COMMENT:` (grey)

This is especially great for multi-phase detection building — mark where your query needs refining or where you’re unsure about data interpretation.

👉 [Better Comments](https://marketplace.visualstudio.com/items?itemName=aaron-bond.better-comments)

---

### 🧭 II. For the Navigating, Note-Taking, Log-Sifting Warrior

The following tools help you find your way, keep your notes straight, and make sense of all those directories, files, and timelines.

### 📁 4. Bookmarks

_Publisher: Alessandro Fragnani_

When you’re sifting through hundreds of lines of logs, Jupyter notebooks, or half-written detections, you need a breadcrumb trail. This plugin lets you:

- Bookmark code lines
- Jump between them like a log-time traveler
- Keep your sanity intact

If your analysis style is part detective, part squirrel — this is for you.

👉 [Bookmarks Extension](https://marketplace.visualstudio.com/items?itemName=alefragnani.Bookmarks)

### 📁 5. Path Intellisense

_Publisher: Christian Kohler_

If your investigation involves navigating directory structures in PowerShell scripts, shell commands, or code analysis — this extension auto-completes file paths in your scripts and queries.

It’s a humble but powerful time-saver.

👉 [Path Intellisense](https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense)

### 📊 6. Excel Viewer

_Publisher: GrapeCity_

Security analysts work in spreadsheets whether we like it or not. This extension lets you open `.xlsx` files directly inside VS Code — no need to summon Excel from the depths of Office bloatware.

Perfect for:

- IOC lists from vendors
- Sysmon export dumps
- CSVs you forgot to convert

👉 [Excel Viewer](https://marketplace.visualstudio.com/items?itemName=GrapeCity.gc-excelviewer)

---

### 🧪 III. For the Integration-Friendly Technomancer

For the analyst who speaks JSON to APIs, who runs prompt-driven pseudomagic, and who believes half the job is knowing _how_ to ask.

### 🧠 7. ChatGPT — Code Companion

_Publisher: GitHub Copilot Labs or extensions like_ `_ChatGPT - CodeGPT_`

Use with caution and a dash of curiosity. AI in your IDE is like a drunk oracle — surprisingly wise but occasionally hallucinatory. Still, ChatGPT plugins in VS Code are excellent for:

- Explaining obfuscated code (yes, even that Powershell base64 blob).
- Generating regex so you don’t have to summon it from memory.
- Writing detections in natural language _before_ translating them into KQL.

Just don’t let it write your detections unattended — it doesn’t have to defend the SOC at 2am.

### 🔄 8. REST Client

_Publisher: Huachao Mao_

Last, but absolutely not least. This is an absolute gem. When working with Defender’s APIs, Microsoft Graph, or custom alerting backends, this plugin lets you send and test HTTP requests directly in a `.http` file inside VS Code.

No need to open Postman. You are Postman now. Go deliver!

👉 [REST Client](https://marketplace.visualstudio.com/items?itemName=humao.rest-client)

---

  

### 🎁 Honourable Mentions

- **Markdown All in One** — For those who write detection docs or blog from VS Code.
- **GitLens** — Know _who_ wrote that terrible correlation rule and _when_.
- **Polacode** — Screenshot beautiful code snippets for your next Medium post or threat intel brief.

---

### 🧘 Final Thoughts

VS Code is more than just an editor — it’s a dojo for your detection kata, a crypt for old scripts, and a cockpit for logflight. But like any good tool, it’s only as powerful as the hands that wield it. So make sure you use it a lot and practice those key commands too.

With these extensions, you’re not just reading logs. You’re navigating them like a pilot with radar, sonar, and a few ESP plugins on the side.

And remember: a well-placed bookmark or colourful comment is sometimes all that separates madness from insight and it what’s make it easier when you squint at those timestamps.
