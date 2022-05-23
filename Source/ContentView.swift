//
//  ContentView.swift
//  K1ModManager
//
//  Created by Lilly on 04/05/2022.
//

import SwiftUI

struct Checkbox: View {
    @State var mod       : Control
    @Binding var current : Control
    @Binding var list    : [Control]
    
    private func toggle() {
        list.contains(mod) ? removeVal() : addVal()
    }
    
    private func addVal() {
        current = mod
        list.append(mod)
    }
    
    private func removeVal() {
        current.name = "Default"
        if let index = list.firstIndex(of: mod) {
            list.remove(at: index)
        }
    }
    
    var body: some View {
        Button(action: toggle) {
            HStack{
                Image(systemName: list.contains(mod) ? "checkmark.square": "square")
                Text(mod.name)
            }
        }
        .disabled(!depCheck(for: mod, in: list))
            .padding()
    }
}

struct ModInfo: View {
    @Binding var mod  : Control
    @Binding var hold : Bool
    @Binding var name : String
    
    var body: some View {
        VStack {
            Text(mod.name)
                .font(.title)
                .padding()
            VStack {
                Text("Developer: " + mod.dev)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(0.5)
                Text("Category: " + mod.cat.rawValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(0.5)
                Text("Tier: \(mod.tier.rawValue)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(0.5)
                Text("Dependencies: " + (mod.deps.isEmpty ? "None" : "\(String(describing: mod.deps).replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "\"", with: ""))"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(0.5)
                Text("Removed Files: " + (mod.rem.isEmpty ? "None" : "\(String(describing: mod.deps).replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "\"", with: ""))"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(0.5)
                Text("Instructions: " + mod.insn)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(0.5)
                Text("Description: " + mod.desc)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(0.5)
            }
            
            if isDownloaded(mod) {
                Button("Install") {
                    hold = true
                    name = "Installing \(mod.name)..."
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if mod.tsl {
                            moveTSLModFiles(from: mod)
                        } else {
                            moveModFiles(from: mod)
                        }
                        
                        hold = false
                        name = "Loading..."
                    }
                }
                .padding()
            } else {
                Button("Download") {
                    hold = true
                    name = "Downloading \(mod.name)..."
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        downloadMod(from: mod.url)
                        
                        hold = false
                        name = "Loading..."
                    }
                }
                .padding()
            }
        }
    }
}

struct ContentView: View {
    @State public var allMods      = controlifyAllMods()
    @State public var selectedMods = [Control]()
    @State public var current      = Control()
    @State public var holding      = false
    @State public var searching    = false
    @State public var holdingName  = "Loading..."
    @State public var searchText   = ""
    
    let firstTimer = firstTime()
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("K1 Mod Manager")
                        .font(.title)
                        .fontWeight(.heavy)
                    
                    Button(action: {
                        current.name = "Default"
                    }) {
                        Image(systemName: "house")
                    }
                    
                    Button(action: {
                        searching = !searching
                        
                        if !searching {
                            current.name = "Default"
                            searchText   = ""
                        }
                    }) {
                        Image(systemName: "magnifyingglass.circle")
                    }
                }
                
                HStack{
                    VStack {
                        if searching {
                            TextField("Search", text: $searchText)
                                .cornerRadius(30)
                                .frame(maxWidth: 300)
                                .onChange(of: searchText) {_ in
                                    if searchText.count == 0 {
                                        current.name = "Default"
                                    } else {
                                        current.name = "Searching..."
                                    }
                                }
                        }
                        
                        ScrollView {
                            if allMods.count > 0 {
                                ForEach(allMods.sorted(), id: \.self) {
                                    Checkbox(mod: $0, current: $current, list: $selectedMods)
                                }
                            } else {
                                Image(systemName: "wifi.slash")
                                Text("Couldn't load mods from server. Are you connected to the internet?")
                            }
                        }
                    }
                    
                    if current.name != "Default" && (current.name != "Searching..." || !searching) {
                        ModInfo(mod: $current, hold: $holding, name: $holdingName)
                    } else if current.name == "Default" {
                        VStack {
                            if selectedMods.count == allMods.count {
                                Button("Deselect All") {
                                    selectedMods = [Control]()
                                }
                                .padding()
                                .padding(.trailing)
                            } else {
                                Button("Select All") {
                                    selectedMods = allMods
                                }
                                .padding()
                                .padding(.trailing)
                            }
                            
                            Button("Download Selected") {
                                holding = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    selectedMods.sorted().forEach { mod in
                                        holdingName = "Downloading \(mod.name)..."
                                        downloadMod(from: mod.url)
                                    }
                                    
                                    showAlert("Finished downloading mods!")
                                    
                                    holding = false
                                    holdingName = "Loading..."
                                }
                            }
                            .disabled(selectedMods.count == 0)
                            .padding()
                            .padding(.trailing)
                            
                            Button("Install Selected") {
                                holding = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    selectedMods.sorted().forEach { mod in
                                        holdingName = "Installing \(mod.name)..."
                                        
                                        if mod.tsl {
                                            moveTSLModFiles(from: mod)
                                        } else {
                                            moveModFiles(from: mod)
                                        }
                                    }
                                    
                                    showAlert("Finished installing mods!")
                                    
                                    holding = false
                                    holdingName = "Loading..."
                                }
                            }
                            .disabled(selectedMods.count == 0)
                            .padding()
                            .padding(.trailing)
                            
                            Button("Setup Environment") {
                                holding = true
                                holdingName = "Setting up environment..."
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    quickerTSLPatching()
                                    
                                    holding = false
                                    holdingName = "Loading..."
                                }
                            }
                            .disabled(FileManager.default.fileExists(atPath: kWinDir + "/users/crossover/Desktop/KOTOR.app"))
                            .padding()
                            .padding(.trailing)
                            
                            Button("Fix Case Sensitivity") {
                                holding = true
                                holdingName = "Fixing case sensitivity..."

                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    tooSimpleSometimesNaïve()

                                    holding = false
                                    holdingName = "Loading..."
                                }
                            }
                            .padding()
                            .padding(.trailing)
                        }
                    } else {
                        ScrollView {
                            if allMods.count > 0 {
                                Text("Search Results")
                                    .font(.title2)
                                
                                ForEach(allMods.sorted(), id: \.self) {
                                    if $0.name.lowercased().contains(searchText.lowercased()) {
                                        Checkbox(mod: $0, current: $current, list: $selectedMods)
                                    }
                                }
                            } else {
                                Image(systemName: "wifi.slash")
                                Text("Couldn't load mods from server. Are you connected to the internet?")
                            }
                        }
                    }
                }
            }
            
            if holding {
                Color(.black)
                    .opacity(0.9)
                VStack{
                    ProgressView()
                    Text("\n\(holdingName)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
