//
//  ModInstaller.swift
//  K1ModManager
//
//  Created by Lilly on 05/05/2022.
//

import Foundation

// Copy all files from the /Override folder of a K1MM-built mod into the actual override folder. Use of shell() instead of cp() intentional.

func moveModFiles(from mod: Control) {
    guard FileManager.default.fileExists(atPath: kGameDir), FileManager.default.fileExists(atPath: kModDir) else {
        showAlert("Couldn't locate game directory and/or mod directory. They should be at:\nGame Directory - \(kGameDir)\nMod Directory - \(kModDir)")
        return
    }
    
    cp(from: kModDir + mod.url + "/Override/.", to: "\(mod.url == "Dialogue_Fixes" ? kGameDir : kGameDir + "override")", force: true)
}

// Copy a TSLPatcher mod's tslpatchdata folder to the TSLPatcher directory and open

func moveTSLModFiles(from mod: Control) {
    guard FileManager.default.fileExists(atPath: kTSLDir + "TSLPatcher.exe") else {
        showAlert("Couldn't locate TSLPatcher. It should be at \(kTSLDir)TSLPatcher.exe")
        return
    }
    
    if FileManager.default.fileExists(atPath: kTSLDir + "tslpatchdata") {
        rm(kTSLDir + "tslpatchdata")
    }
    
    cp(from: kModDir + mod.url + "/tslpatchdata", to: kTSLDir + "tslpatchdata")
    shell("/usr/bin/open", [kTSLDir])
    showAlert("Attempting to install \(mod.name) via TSLPatcher. Please press OK when finished.\n\nInstructions: \(mod.insn)")
    whoIsRem(mod)
}

// Create K1_Mods and K1_Tools directories, copy TSLPatcher to K1_Tools, extract KOTOR.app from the .ipa, and symbolically link to the game directory in the desktop of a Crossover bottle

func quickerTSLPatching() {
    FileManager.default.changeCurrentDirectoryPath(kDownDir)
    
    guard FileManager.default.fileExists(atPath: kDownDir + "/TSLPatcher.exe"), FileManager.default.fileExists(atPath: kDownDir + "/KOTOR_1.2.7.ipa") else {
        showAlert("Please ensure that both TSLPatcher.exe and KOTOR_1.2.7.ipa are in the ~/Downloads directory")
        return
    }
    
    guard FileManager.default.fileExists(atPath: kWinDir) else {
        showAlert("Please ensure that a CrossOver bottle named Windows10 exists")
        return
    }
    
    mkdir(kDocsDir + "/K1_Mods")
    mkdir(kWinDir + "/K1_Tools")
    
    cp(from: kDownDir + "/TSLPatcher.exe", to: kWinDir + "/K1_Tools/TSLPatcher.exe")
    
    shell("/usr/bin/unzip", ["-o", kDownDir + "/KOTOR_1.2.7.ipa"])
    
    cp(from: kDownDir + "/Payload/KOTOR.app", to: kDocsDir + "/KOTOR.app")
    rm(kDownDir + "/Payload")
    
    shell("/bin/ln", ["-s", kGameDir, kWinDir + "/users/crossover/Desktop/KOTOR.app"])
}

// Determine if a given mod is currently downloaded to the system (NOT necessarily added to the game)

@inline(__always) func isDownloaded(_ mod: Control) -> Bool {
    return FileManager.default.fileExists(atPath: kModDir + mod.url)
}

// Determine if a dependency is currently selected for installation

func depCheck(for mod: Control, in list: [Control]) -> Bool {
    if mod.deps.count == 0 {
        return true
    }
    
    for dep in mod.deps {
        for sel in list {
            if dep == sel.url || FileManager.default.fileExists(atPath: kGameDir + "override/" + dep) {
                return true
            }
        }
    }
    
    return false
}

// Remove files from TSLPatcher mods that can cause problems for whatever reason. I can confirm that this fixes crashes in-game!

func whoIsRem(_ mod: Control) {
    for file in mod.rem {
        if FileManager.default.fileExists(atPath: kGameDir + "override/" + file) {
            rm(kGameDir + "override/" + file, force: true)
        }
    }
}
