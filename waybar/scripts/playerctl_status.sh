#!/bin/bash

status=$(playerctl status 2>/dev/null)

if [ "$status" = "Playing" ]; then
    icon="⏸"
elif [ "$status" = "Paused" ]; then
    icon="▶"
else
    echo ""
    exit 0
fi

title=$(playerctl metadata title 2>/dev/null)
artist=$(playerctl metadata artist 2>/dev/null)

echo "$icon $artist - $title"

