---
title: "Beginner Mistakes in KQL"
date: 2025-07-03
description: Finding your inner join in a leftouter world
categories: [logwatchers-zenit]
tags: [threat-hunting, threat-detection, incident-response, kql]
image:
  path: "/assets/img/blog/2025-07-03-logwatchers-zenit-05/logwatchers-zenit-title-05.png"
  alt: Logwatcher's Zenit 05
---

*Finding your inner join in a leftouter world.*

#### Introduction
At the summit of signal and noise lies the Logwatcher’s Zenit — a quiet place for analysts who squint at timestamps and whisper to correlation engines. Bring your coffee, leave your assumptions at home, and why come alone?

#### The Fog of Query
Somewhere between your fifth cup of coffee and the fourth attempt at making `summarize` do something useful, it hits you: **KQL is deceptively simple**. You write a few lines, get some rows back, and suddenly you’re riding high on the wave of insight.

Until… it breaks.

> “Why is my result empty?”
> “Why did this join create 400,000 rows?”
> “Why does this chart look like a haunted barcode?”

Fear not, fellow signal-seeker. Every hunter has tripped on these same twigs in the dark forest of logland. Let us confess, forgive, and learn. Here are seven common missteps — and how to avoid them.

---

#### 🪞 1. Projecting Too Much (Or Too Little)
`DeviceLogonEvents | project *`

The KQL version of grabbing every dish at the buffet. Often used out of habit or panic. And while it seems harmless, `project *` brings in every column — including long dynamic fields — which can clutter your results, ruin visuals, and make you miss the important bits.

✅ Do This Instead:

`DeviceLogonEvents | project Timestamp=TimeGenerated, AccountName, LogonType, DeviceName`

Pick what you need. Let your query breathe.

—--

#### 🌀 2. `summarize` Without Direction
`SigninLogs | summarize count()`

It returns a single row. Powerful… but mostly meaningless. Summarize is only interesting with context — what are you grouping by? What are you counting?

✅ Use `summarize` With Purpose:

`SigninLogs | where ResultType == 50074 | summarize FailedLogins = count() by bin(TimeGenerated, 1h), UserPrincipalName`

Add a `bin()` . Add dimensions. Add clarity. Don’t just count — count with meaning. I talked about that in ![this blog post](https://threathunter-chronicles.com/blog/logwatchers-zenit/histogram-the-weight-measurement-of-logs.html); “Histogram, the Weight Measurement of Logs”.

---

#### 🕰️ 3. Forgetting Time Exists
`Heartbeat | summarize count() by Computer`

No time filter? Welcome to the Land of Empty Results or Eternal Slowness.

✅ Always Respect the Clock:

`Heartbeat | where TimeGenerated > ago(1d) | summarize count() by Computer`

Time is not just a column. It’s the backbone of every hunt.

---

#### 🔍 4. Using == for Everything
`DeviceNetworkEvents | where RemoteUrl == "threathunter-chronicles"`

String filters trip up many. == expects an exact match — and logs are rarely that clean.

✅ Prefer Flexible Operators:

`DeviceNetworkEvents | where RemoteUrl has "threathunter-chronicles"`

Use `has`, `contains`, or even `matches regex` when dealing with noisy, unstructured data.

---

#### 📦 5. Ignoring Dynamic Data
`AzureDiagnostics | project Properties.SomeNestedField`

This fails unless `Properties` is already parsed. And no, KQL won’t do it for you.

✅ Know Thy `parse_json()`:

`AzureDiagnostics | extend props = parse_json(Properties) | project props.SomeNestedField`

Dynamic fields are like onions. You’ve got to peel them.

---

#### 🧩 6. Joining Without Guardrails
`DeviceLogonEvents | join kind=inner (IdentityInfo) on AccountName`

And suddenly, you have 14 million rows. Joins are powerful — but dangerous without a primary key strategy.

✅ Use Clean Keys and Joins That Make Sense:

`DeviceLogonEvents | summarize LastSeen=max(TimeGenerated) by AccountName | join kind=inner (IdentityInfo | summarize LastInfo=max(TimeGenerated) by AccountName) on AccountName`

Think about cardinality. Are you joining 1:1 or 1:many? Use `kind=leftouter` to keep your base table intact.

---

#### 🧠 7. Thinking It’s Just SQL
`SELECT * FROM SecurityEvent WHERE EventID = 4625;`

Nope.

KQL isn’t SQL. It’s built for log streams, not relational databases. Learn to think in *pipes*, not nested queries. KQL isn’t about tables — it’s about signal transformation.

---

#### 🎓 Final Thoughts from the Zenit
Every query is a meditation.

It teaches you not just about the data, but about *how you think*. KQL invites curiosity, iteration, and — when the results are just right — a small flicker of joy.

You’ll mess up joins. You’ll overproject. You’ll forget `bin()`. We all do. Trust me. But you’ll learn.

> But the true hunter learns. Not just from success — but from every failed query that whispered, “Almost.”

---

#### 🧪 Bonus Challenge — Can You Fix This Query?
Here’s one I’ve seen in the wild. Can you spot and fix the issues? It’s an easy one.

```kql
SecurityEvent
| where EventID == "4625" or EventID == "4624"
| summarize count() by Account, bin(TimeGenerated, 1h)
| where Account != ""
```

Drop your fix in the comments — and tell me why.

---

#### 🙏 Thanks for Reading
Got your own KQL sins to confess? Or maybe some lessons from the trenches? Share them with me — this Zenit has room for all Logwatchers.

Until next time: bin your timestamps, parse your JSON, and always bring snacks and coffee to the incident call. And may your joins be inner.
