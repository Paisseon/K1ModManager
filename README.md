# WIP

The app is fully completed, and I am now testing the build in-game.

**Current Progress**: 2/4 Star Maps, currently on Manaan.

**Playing as a**: Female light-side Scoundrel 1/Consular X. Bastila route ofc. Doing *every* sidequest.

**Issues Encountered**
- The UI labels are for desktop, e.g. Auto Run is called Mouse Look. No impact on mechanics.            | Culprit: K1CP?
- Some weapons, e.g. Sith Assassin Pistol, have black boxes for icons. No impact on in-game appearance. | Culprit: HD Blasters
- Helena Shan does not have a unique appearance.                                                        | Culprit: Helena Shan Improvement?

Further bulletins as events warrant.

# KOTOR 1 Mod Manager

Welcome to KOTOR 1 Mod Manager (K1MM for short), a tool designed to allow easy and simple installation of mods for the iOS version of KOTOR 1. Please be aware that K1MM currently only supports mods from [Snigaroo's mobile build](https://www.reddit.com/r/kotor/wiki/k1fullbuildmobile) and a few hand-selected mods with compatibility. Now with that out of the way, let's start with the setup necessary to get your mods installed. It's very easy-- just follow the steps under **Setup Instructions** and you'll be good to go.

*If you have not played KOTOR before, ONLY read the description in the K1MM app as the TSLPatcher descriptions contain spoilers!*

**Required Apps**
- [AltStore](https://altstore.io) OR [Sideloadly](https://sideloadly.io) OR Jailbroken
- [CrossOver](https://www.codeweavers.com/crossover/download) \*
- [KOTOR 1](https://apps.apple.com/dk/app/star-wars-kotor/id416608891?l=da&amp;mt=12) \*\*
- [TSLPatcher](https://krakenfiles.com/view/bBElfO1sv0/file.html) \*\*\*

\* Paid, but can be pirated or use the 14 day trial. Accept no substitutes.

\*\* You will need an .ipa file for this. I [fly the Jolly Roger](https://0bin.net/paste/htdgPTtm#bgKxFLE44xy24hbncVIXwceVXhpZo2kkWc8qQTstqbG), but CrackerXI+ (if jailbroken) or [ipatool](https://github.com/Paisseon/ipatool/releases/tag/v1.1.0-paisseon) can also help.

\*\*\* Has to be this linked file (or download K1CP and take from it) and not another, as K1CP has trouble with other versions of TSLPatcher

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
1. Remove the KOTOR *symlink* from ~/Downloads/KOTOR.app, which is 33 B. **Don't** remove the 14,1 MB executable of the same name!
2. Create a folder anywhere called Payload
3. Copy ~/Downloads/KOTOR.app to Payload
4. Compress Payload to Payload.zip
5. Rename Payload.zip to Payload.ipa
6. Sideload Payload.ipa to your iOS device

Done! You can now play KOTOR with mods =)

Please let me know if the mod installer acts up, and if a problem occurs after the .ipa is sideloaded, let u/Snigaroo on Reddit know.
