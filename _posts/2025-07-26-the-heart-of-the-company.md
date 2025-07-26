---
title: "KQLture Club #01: The ❤️ of the Company"
date: 2025-07-26
description: A Reaction Says More Than Thousand Replies
categories: [kqlture-club]
tags: [threat-hunting, threat-detection, incident-response, emojis]
image:
  path: "/assets/img/blog/2025-07-26-kqlture-club-01/kqlture-club-title-01.png"
  alt: KQLture Club 01
---

## Introduction
*Some queries are built to detect threats. Others are built to detect existential dread in the event timeline. KQLture Club is where we celebrate the latter. Here, SIEM-ingly useless queries, ironic detections, and overly elegant extend statements mingle in a haze of semi-functional genius. It's part performance art, part security (who am I kidding) telemetry. Think of it as poetry colliding with a parser at light speed. What could possibly go wrong?*

## Emoji Hunting
A [colleague](https://hedbergtech.se/) and I was working on an incident tracking down the patient zero, and the initial Teams message that started the whole thing. While digging through the meta information of messages we notices that there was an `ActionType` called `"ReactedToMessage"` . That later became one of this rabbit holes. One of the really fun ones.<br>
Imagine if you could write a KQL query to see which emojis have been used to react to messages. Wouldn't that say a lot about the company you're working for?

## Welcome to the KQLture Club…
…the only place on the Internet where it's possible. Because this is the club where every KQL nerd is welcome. This is the club where we take a break from being Logwatchers.
In M365 Defender, if you have a Defender for Office license, you should have a schema called [CloudAppEvents](https://learn.microsoft.com/en-us/defender-xdr/advanced-hunting-cloudappevents-table?wt.mc_id=MVP_387063). This schema contains all events related to Teams and other applications.<br>
To track down emoji reactions in Microsoft Teams, start by filtering the `Application` column for `"Microsoft Teams"`. Then narrow things further by setting `ActionType` to `"ReactedToMessage"` because yes, that counts as an action, even if it's just a thumb-up, or coffee, or a thumb-up made of coffee.

![Thumbs-Up Coffee](/assets/img/blog/2025-07-26-kqlture-club-01/kqlture_club_thumb-up_emoji_made_of_coffee.png)

The emoji itself plays a bit of hide-and-seek in the logs so we need to parse the `RawEventData` JSON, and then you'll find it nestled under `"MessageReactionType"`. To get there, use a combination of `parse_json` and `tostring`. Think of them as your EXT; *Emoji eXtraction Toolkit*.<br>
Finally, count the appearances of each emoji using `summarize` and sort them by `count_` in descending order. Voilà: a leaderboard of emotional shorthand, from the overused flames and strong arms to the rare, philosophical shrug.

## The KQL Query

```KQL
CloudAppEvents
| where Application == "Microsoft Teams"
| where ActionType == "ReactedToMessage"
| summarize count() by tostring(parse_json(RawEventData)["MessageReactionType"])
| order by count_ desc
```

Should your result contain something like `;0-csea-d8-` followed by a suspiciously long string of HEX characters (32, to be precise, because chaos still has rules of course), then you, dear KQLture Club member, have encountered a user-uploaded emoji and depending on how much free time your colleagues might have, there can be quite a lot of them after a while. The bit before the semicolon? That's the emoji's chosen name by the uploader. Perhaps something like `this-is-fine-fire;0-csea-d8-...`. Why are they named like this? Well, who besides us are reading these logs anyway? 🤷🏼‍♂️🤷🏼‍♀️

## 🔎 Emoji Detections
Why not turn this query into a full blown *Custom Detection* and surprise your SOC colleagues with an alert every time a certain emoji is being used? Use your imagination and be creative but don't drain your colleagues by creating EAF; * Emoji Alert Fatigue*.

## 🧘🏼‍♂️ Closing Notes
You can draw your own conclusions on what type of company you're working for based on the most used emoji. Remember that you can only look 30 days back unless you've shipped the log to a storage with a longer retention time. This could be your legacy, though. Storing logs full of emojis on old fashioned physical disks (ask your parents) and put them in a long forgotten cellar for future generations to find.

Again, I mean… what could possibly go wrong? 🙄🙃
