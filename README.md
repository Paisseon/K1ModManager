# KOTOR 1 Mod Manager

Welcome to KOTOR 1 Mod Manager (K1MM for short), a tool designed to allow easy and simple installation of mods for the iOS version of KOTOR 1. Please be aware that K1MM currently only supports mods from [Snigaroo's mobile build](https://www.reddit.com/r/kotor/wiki/k1fullbuildmobile) and a few hand-selected mods with compatibility. Now with that out of the way, let's start with the setup necessary to get your mods installed. It's very easy-- just follow the steps under **Setup Instructions** and you'll be good to go.

**Required Apps**
- [AltStore](https://altstore.io) OR [Sideloadly](https://sideloadly.io)
- [CrossOver](https://www.codeweavers.com/crossover/download)
- [KOTOR 1](https://apps.apple.com/dk/app/star-wars-kotor/id416608891?l=da&amp;mt=12) \*
- [TSLPatcher](https://deadlystream.com/files/file/1039-tsl-patcher-tlked-and-accessories/)

\* You will need an .ipa file for this. I [fly the Jolly Roger](https://0bin.net/paste/htdgPTtm#bgKxFLE44xy24hbncVIXwceVXhpZo2kkWc8qQTstqbG), but CrackerXI+ (if jailbroken) or [ipatool](https://github.com/Paisseon/ipatool/releases/tag/v1.1.0-paisseon) can also help.

**Setup Instructions**
1. Rename your .ipa file to KOTOR_1.2.7.ipa and ensure that it is located at ~/Downloads/KOTOR_1.2.7.ipa
2. Ensure that TSLPatcher is located at ~/Downloads/TSLPatcher.exe
3. Open CrossOver and create a 64-bit Windows 10 bottle named, exactly: Windows10
4. Open K1MM from /Applications and click on Setup Environment

**Installing Mods**
1. Select mods from the list of checkboxes on the left, or click Select All on the right if you want the full build
2. Click Download Selected. This may take a minute as the full build is approximately 1 GB
3. When the download is finished (it will tell you), click Install Selected
4. As mods install, you will see alerts about TSLPatcher. Only click these **AFTER** you have fully installed the TSLPatcher mod, as doing otherwise will cause problems.
5. When the install is finished (it tells you this, too), click Fix Case Sensitivity

**Moving to Device**
1. Create a folder anywhere called Payload
2. Copy ~/Downloads/KOTOR.app to Payload
3. Remove the 33 B **symlink** KOTOR (not the 14.8 MB executable!) from Payload/KOTOR.app
4. Compress Payload to Payload.zip
5. Rename Payload.zip to Payload.ipa
6. If not jailbroken: Sideload Payload.ipa to your iOS device using AltStore/Sideloadly
7. If jailbroken: Transfer Payload.ipa to your iOS device using iMazing/Xenon/SCP/etc. and install using AppSync Unified

Done! You can now play KOTOR with mods =)
