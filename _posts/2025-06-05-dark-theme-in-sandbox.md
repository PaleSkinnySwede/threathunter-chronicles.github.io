---
title: "Dirty Bit #01: Dark Theme in Sandbox"
date: 2025-06-05
description: Force dark theme on launch, kill the evidence, walk away
categories: [dirty-bits]
tags: [dark-mode, dark-theme, windows, sandbox]
image:
  path: "/assets/img/blog/2025-06-05-dirty-bit-01/dirty-bit-title-01.png"
  alt: Dirty Bit 01
---

_Force dark theme on launch, kill the evidence, walk away_

This is filed under: Questionable methods. Unquestionable results.

## SV;TC (Short Version;Time for Coffee)

1. Edit your `.wsb` file and map a folder and add a command  
2. Create a `.cmd` file with the dark theme command  
3. Done

The _Dirty Bits_ category celebrates the unsung heroes of quick hacks, undocumented flags, and the kind of logs that smell slightly burnt. Here, we practice questionable methods with unquestionable results. This is the dusty corner of computing where the manuals end and the real fun begins. Don’t panic. BYOP _(Bring Your Own Parsers)_ and `sudo` responsibly.

I’m a night owl suffering from snow blindness. So I it can’t come as a surprise when I tell you that I’m a Dark Mode Advocate trying to eliminate bright screens wherever I can. Imaging getting a phone call in the middle of the night and powering on your 4k monitor to see a white and bright UI. Big no-no.

I mean, like this… BRIGHT LIGHT!

![Bright Light](/assets/img/blog/2025-06-05-dirty-bit-01/bright-screen.gif)
*Sharing is caring.*

Now you know what I’m experiencing when the on-call phone rings in the middle of the night.

One thing that bugged me was that the [Sandbox](https://learn.microsoft.com/en-us/windows/security/application-security/application-isolation/windows-sandbox/?wt.mc_id=MVP_387063) in [Windows 11](https://www.microsoft.com/en-us/windows/windows-11/?wt.mc_id=MVP_387063) always starts with the awfully bright theme as default. It doesn’t matter what your host operating system is set to — the Sandbox is always white, because Microsoft has decided that for you.

But, look no further because here’s my neat little trick that solves it for you.

Open your Sandbox `.wsb` file in your favourite text editor. Mine is [Visual Studio Code](https://code.visualstudio.com/) (surprise!), but Notepad works fine for a quick and dirty hack like this too.

If you’re new to configuring your Sandbox, [Microsoft has a great article about it](https://learn.microsoft.com/en-us/windows/security/application-security/application-isolation/windows-sandbox/windows-sandbox-configure-using-wsb-file/?wt.mc_id=MVP_387063).

## Editing the .wsb file

For this dark theme hack to work, you need to map a folder from your host system to your Sandbox. You do this by adding the following lines to the `<MappedFolders>` section in your `.wsb` file:

```
<MappedFolder>  
  <HostFolder>C:\Users\ThreatHunterChronicles\Scripts</HostFolder>  
  <SandboxFolder>C:\Users\WDAGUtilityAccount\Documents\Scripts</SandboxFolder>  
</MappedFolder>
```

Add the following three lines before `</Configuration>` :

```
<LogonCommand>  
  <Command>C:\Users\WDAGUtilityAccount\Documents\Scripts\WSBstartup.cmd</Command>  
</LogonCommand>
```

## Create the .cmd file

Create a new file called `WSBstartup.cmd` in the `HostFolder` folder that you specified in the `.wsb` file and add these two lines:

```
C:\Windows\Resources\Themes\dark.theme  
taskkill /IM systemsettings.exe /F
```

Save it and you’re done. It’s really that simple. Beautiful, isn’t it? 😎

I know you might question the method, but the result is glorious!

If bits could kill.
