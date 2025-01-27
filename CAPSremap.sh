#!/bin/bash
# Check if Caps Lock is on
if xset q | grep -q "Caps Lock:   on"; then
    echo "Caps Lock is currently ON. Please turn it off before remapping."
    exit 1
fi

# Remap Caps Lock to Escape for the current session
setxkbmap -option caps:escape
echo "Caps Lock has been remapped to Escape."
