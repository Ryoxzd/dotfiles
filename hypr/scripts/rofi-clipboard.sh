#!/bin/bash

choice=$( (echo "🗑 Clear Clipboard"; cliphist list) | rofi -dmenu -p "Clipboard")

if [[ "$choice" == "🗑 Clear Clipboard" ]]; then
    cliphist wipe
    notify-send -i /usr/share/icons/Papirus-Dark/24x24/panel/clipboard.svg "Clipboard Cleared!"
elif [[ -n "$choice" ]]; then
    cliphist decode <<< "$choice" | wl-copy
fi

