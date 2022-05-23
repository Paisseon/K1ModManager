//
//  ControlReader.swift
//  K1ModManager
//
//  Created by Lilly on 05/05/2022.
//

import Foundation

// Convert the contents of a JSON-encoded control file into a readable Control struct

func readControl(for controlFile: Dictionary<String, Any?>) -> Control {
    guard controlFile["name"] != nil, controlFile["developer"] != nil else {
        showAlert()
        fatalError()
    }
    
    guard let name  = controlFile["name"] as? String,
          let order = controlFile["order"] as? UInt,
          let tsl   = controlFile["tsl"] as? Bool,
          let deps  = controlFile["dependencies"] as? [String],
          let url   = controlFile["url"] as? String,
          let dev   = controlFile["developer"] as? String,
          var insn  = controlFile["instructions"] as? String,
          let desc  = controlFile["description"] as? String else {
        showAlert()
        fatalError()
    }
    
    let rem = controlFile["remove"] as? [String] ?? [String]()
    
    var cat: Category
    var tier: Tier
    
    switch controlFile["category"] as? Int {
        case 0:
            cat = Category.added
        case 1:
            cat = Category.appearance
        case 2:
            cat = Category.bugfix
        case 3:
            cat = Category.graphics
        case 4:
            cat = Category.immersion
        case 5:
            cat = Category.mechanics
        case 6:
            cat = Category.multi
        case 7:
            cat = Category.patch
        default:
            cat = Category.restored
    }
    
    switch controlFile["tier"] as? Int {
        case 1:
            tier = Tier.essential
        case 2:
            tier = Tier.recommended
        case 3:
            tier = Tier.suggested
        default:
            tier = Tier.option
    }
    
    if insn == "-" {
        insn = tsl ? "Run TSLPatcher.exe" : "None"
    }
    
    return Control(name: name, order: order, cat: cat, tier: tier, tsl: tsl, deps: deps, insn: insn, url: url, dev: dev, desc: desc, rem: rem)
}

// Fetch the mod list from GitHub and read it. This is cached, much to my chagrin.

func controlifyAllMods() -> [Control] {
    var output = [Control]()
    
    guard let buildList: Dictionary = try? JSONSerialization.jsonObject(with: Data(contentsOf: URL(string: "https://raw.githubusercontent.com/Paisseon/K1ModManager/emt/control.json")!, options: [])) as? Dictionary<String, Any?> else {
        showAlert("Failed to read mod list from server")
        return [Control]()
    }
    
    buildList.forEach {
        guard let dict: Dictionary<String, Any?> = $1 as? Dictionary<String, Any?> else {
            showAlert()
            fatalError()
        }
        
        let control = readControl(for: dict)
        
        output.append(control)
    }
    
    return output
}
