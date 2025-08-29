---
title: "Logwatcher's Zenit #07: Let There Be Let"
date: 2025-08-29
description: Let there be logs, and there was telemetry
categories: [logwatchers-zenit]
tags: [threat-hunting, threat-detection, incident-response, mitre-attack]
image:
  path: "/assets/img/blog/2025-08-29-logwatchers-zenit-07/logwatchers-zenit-title-07.png"
  alt: Logwatcher's Zenit 07
---

#### Introduction
*At the summit of KQL mastery lies a deceptively humble keyword: `let`. Whispered by seasoned threat hunters and war-scarred incident responders alike, it’s not just a macro tool—it’s a language of intention. Let me show you how. But first, coffee.*


## Let's Get Started
Microsoft has a great (Learn page about Let)[https://learn.microsoft.com/en-us/kusto/query/let-statement?view=microsoft-fabric&wt.mc_id=MVP_387063]. I'm going to walk you through how I'm using `let` to store variables and cache results from sub-queries which I then can use onwards in my queries. When I come across a set of fixed data that I need to use over and over again, like a username, an IP address or a hash, I'm using `let`.

### The Syntax and Special Functions
`let` Variable `=` `function(`[ Parameters ]`)`

The syntax is quite easy. It's (obviously) the word `let` followed by a variable name that you get to choose yourself. After the variable name comes the `=` and then a function; like `datatable()`, `dynamic()` or `materialize()`. Then you have a the body of the function.

Be smart and make it memorable and something that actually has something to do with the result or what you're trying to acheive. Naming the variable `fawoeija` because you're running low on caffeine will only make it harder later when your query grows beyond 50 lines or so. 


## 1. Creating a List of Things
Here's a quick exmple creating a list, or array:

```kql
let ThreatIPs =
[
	"185.203.116.8",
	"185.225.73.103",
	"45.9.148.22"
];
DeviceNetworkEvents
| where RemoteIP in (ThreatIPs)
```

**Use case:** It's easier to have a list of IPs, usernames, or other bits of IOCs at the top of the query instead of having the data scattered all over the place.


## 2. Portable Patterns
But, to make a better use of the data, and structure it so it can be parsed in a more efficient way, we can use the `dynamic()` function. This will create a json-like structure and can be parsed like this:

```kql
let ThreatIPs = dynamic(
[
	"185.203.116.8",
	"185.225.73.103",
	"45.9.148.22"
]);
DeviceNetworkEvents
| extend ipMatch = array_index_of(ThreatIPs, RemoteIP)
```

## 3. The Datatable
The above example is fast and efficient, if the list is short. Like, really short. If the list is longer and has more fields that you'd like to correlate, you should use `datatable()` instead. Like this:

```kql
let ThreatIPs = datatable(IP:string, Port:string)
[
    "185.203.116.8", "80",
    "45.9.148.22", "8080",
    "185.225.73.103", "443"
];
DeviceNetworkEvents
| join kind=inner (ThreatIPs) on $left.RemoteIP == $right.IP
```

**Use case:** Persistently reused threat indicators, known payload URLs, or internal “grey zones.” Your pattern will become a mini signature. Sort of.


## 4. Nested Queries

This example is a bit weird at the first glance. The `SuspiciousProcess` will contain the result from the `DeviceProcessEvents` query which will then be used to query the `DeviceFileEvents` schema where the `DeviceId` is the same. It's a very effective way to enrich your result, or get more info about your presumed *patient zero*.

The special function we're using here, `materialize()`, is particularly great if the query, or sub-query, contains heavy calculations. Then you can store the result from that in a variable using `let` and re-use the result without running the calculation again. Here is more info about (Materialize)[https://learn.microsoft.com/en-us/kusto/query/materialize-function?view=microsoft-fabric&wt.mc_id=MVP_387063] on Microsoft Learn.

```kql
let SuspiciousProcesses = materialize(
  DeviceProcessEvents
	| where InitiatingProcessCommandLine has_any ("bitsadmin", "certutil", "rundll32")
	| summarize by DeviceId, InitiatingProcessId
);
DeviceFileEvents
| join kind=inner (SuspiciousProcesses) on DeviceId
```

**Use case:** Set up intermediate logic or context that you reference later in a clean and readable way, and that is cached so it's retreived swiftly. It also helps avoid nesting madness.

## 🔮 Closing Thought

Use the right function for the right time. The real power of `let` is not in avoiding repetition but in _designing meaning into your hunt_. It’s how experienced analysts turn queries into strategy, rules into context, and data into understanding.

*“Let there be logs,” said the hunter, and there was telemetry.”*
