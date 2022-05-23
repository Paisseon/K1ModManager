//
//  Definitions.swift
//  K1ModManager
//
//  Created by Lilly on 05/05/2022.
//

import AppKit

// Constants for directory paths that I don't care to copy and paste a couple dozen times

let kDocsDir = ("~/Documents/" as NSString).expandingTildeInPath
let kDownDir = ("~/Downloads/" as NSString).expandingTildeInPath
let kModDir  = kDocsDir + "/K1_Mods/"
let kGameDir = kDocsDir + "/KOTOR.app/"
let kLibDir  = ("~/Library/" as NSString).expandingTildeInPath
let kWinDir  = kLibDir + "/Application Support/CrossOver/Bottles/Windows10/drive_c/"
let kTSLDir  = kWinDir + "K1_Tools/"

// Pretty simple enums. Not exactly sure why I used them instead of String and Int

enum Category: String {
    case added      = "Added Content"        // 0
    case appearance = "Appearance Change"    // 1
    case bugfix     = "Bugfix"               // 2
    case graphics   = "Graphics Improvement" // 3
    case immersion  = "Immersion"            // 4
    case mechanics  = "Mechanics Change"     // 5
    case multi      = "Multiple Categories"  // 6
    case patch      = "Patch"                // 7
    case restored   = "Restored Content"     // 8
}

enum Tier: Int {
    case essential   = 1
    case recommended = 2
    case suggested   = 3
    case option      = 4
}

// The Control struct is read from the control file, which I have added to each mod in the build for convenience

struct Control: Hashable, Comparable {
    static func < (lhs: Control, rhs: Control) -> Bool {
        lhs.order < rhs.order
    }
    
    var name  : String   = "Default"    // KOTOR Dialogue Fixes
    var order : UInt     = 999          // 0
    var cat   : Category = .mechanics   // Category.immersion
    var tier  : Tier     = .essential   // Tier.essential
    var tsl   : Bool     = false        // false
    var deps  : [String] = []           // []
    var insn  : String   = "-"          // "Move the dialogue.tlk file to KOTOR.app."
    var url   : String   = "Default"    // "Dialogue_Fixes"
    var dev   : String   = "Lilliana"   // "Salk & Kainzorus Prime"
    var desc  : String   = "Dream Luck" // "Improve dialogue throughout the game."
    var rem   : [String] = []           // []
}

// Display an error alert and return to the app

func showAlert(_ msg: String = "Your entire party has been killed. Return to main menu.") {
    NSSound(named: "EmiliaSayingBeep")?.play()
    
    let alert = NSAlert()
    alert.alertStyle = .critical
    alert.messageText = "KOTOR Mod Manager"
    alert.informativeText = msg
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

// Spawn a process to execute shell commands. Causes a panic if the command fails.

func shell(_ launchPath: String, _ arguments: [String]) {
    let process = Process()
    
    process.launchPath = launchPath
    process.arguments = arguments
    process.launch()
    process.waitUntilExit()
    
    if process.terminationStatus != 0 {
        if launchPath == "/usr/bin/unzip" && process.terminationStatus == 1 {
            return
        }
        
        showAlert("Command 「 \(launchPath) \(String(describing: arguments).replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ",", with: "")) 」 failed with exit code \(process.terminationStatus).")
        fatalError()
    }
}

// Ez function to delete files. Substitute this for shell calls to /bin/rm

func rm(_ path: String, force: Bool = false) {
    if force {
        shell("/bin/rm", ["-rf", path])
        return
    }
    
    if FileManager.default.fileExists(atPath: path) {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch (let error) {
            showAlert("Couldn't delete item located at \(path)\n\nError: \(error)")
            fatalError()
        }
    }
}

// Ez function to copy and overwrite existing files. Substitue this for shell calls to /bin/cp

func cp(from src: String, to dest: String, force: Bool = false) {
    if force {
        shell("/bin/cp", ["-R", src, dest])
        return
    }
    
    do {
        if FileManager.default.fileExists(atPath: dest) {
            try FileManager.default.removeItem(atPath: dest)
        }
        
        try FileManager.default.copyItem(atPath: src, toPath: dest)
    } catch (let error) {
        showAlert("Couldn't copy item at \(src) to \(dest)\n\nError: \(error)")
        fatalError()
    }
}

// Ez function to move files. Substitute this for shell calls to /bin/mv

func mv(from src: String, to dest: String) {
    do {
        if FileManager.default.fileExists(atPath: dest) {
            try FileManager.default.removeItem(atPath: dest)
        }
        
        try FileManager.default.moveItem(atPath: src, toPath: dest)
    } catch (let error) {
        showAlert("Couldn't copy item at \(src) to \(dest)\n\nError: \(error)")
    }
}

// Ez function to create directories. Substitute this for shell calls to /bin/mkdir

func mkdir(_ path: String) {
    do {
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
    } catch (let error) {
        showAlert("Couldn't create directory at \(path)\n\nError: \(error)")
        fatalError()
    }
}

// Fix mods in which the developer was too simple and sometimes naïve in their assumption of case-insensitive systems

func tooSimpleSometimesNaïve() {
    FileManager.default.changeCurrentDirectoryPath(kGameDir)

    var tmpc = [String]()
    let tmpv = ["override", "modules", "streamsounds", "streamwaves"]
    
    for tmp in tmpv {
        shell("/usr/bin/zip", ["-0", "-r", tmp + ".zip", tmp])
        mv(from: tmp, to: tmp + "-backup")
        shell("/usr/bin/unzip", ["-LL", "-qq", tmp + ".zip"])
        
        tmpc.append(tmp + "-backup")
        tmpc.append(tmp + ".zip")
    }
    
    for item in tmpc {
        rm(item)
    }
}

// Show the readme to first time users

func firstTime() -> Bool {
    if UserDefaults.standard.bool(forKey: "ItsNotLikeIWantYouToReadMeOrAnythingBaka") != true {
        UserDefaults.standard.set(true, forKey: "ItsNotLikeIWantYouToReadMeOrAnythingBaka")
        NSWorkspace.shared.open(URL(string: "https://github.com/Paisseon/K1ModManager#readme")!)
    }
    
    return true
}
