#!/bin/sh

println() {
    printf '%s\n' "$*"
}

test ! -d ~/Documents/K1_Mods; then
    println "Creating K1_Mods directory..."
    mkdir -p ~/Documents/K1_Mods
fi

test ! -d ~/Library/Application\ Support/CrossOver/Bottles/Windows10/drive_c; then
    println "Crossover bottle Windows10 doesn't exist!"
    exit
fi

test ! -d ~/Library/Application\ Support/CrossOver/Bottles/Windows10/drive_c/K1_Tools; then
    println "Creating K1_Tools directory..."
    mkdir -p ~/Library/Application\ Support/CrossOver/Bottles/Windows10/drive_c/K1_Tools
fi

test ! -f ~/Downloads/TSLPatcher.exe; then
    println "TSLPatcher.exe is not located at ~/Downloads/TSLPatcher.exe!"
    exit
fi

println "Copying TSLPatcher to K1_Tools..."

cp -R ~/Downloads/TSLPatcher.exe ~/Library/Application\ Support/CrossOver/Bottles/Windows10/drive_c/K1_Tools/TSLPatcher.exe

println "Done!"
