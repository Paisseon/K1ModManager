#!/bin/sh

println() {
    printf '%s\n' "$*"
}

cd ~/Documents/KOTOR.app/override/

files="*"

for file in $files; do
    if test "${file: -4}" == ".tpc"; then
        name="$(echo $file | cut -d'.' -f1)"
        
        if test -f "$name.tga"; then
            println "$file is a duplicate!"
            rm -rf "$file"
        fi
        
    elif test -L "$file"; then
        println "$file is a symlink!"
        unlink "$file"
    fi
done
