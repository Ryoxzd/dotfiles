#!/bin/bash

options="⏻ Shutdown\n Reboot\n Suspend\n Logout"

choice=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu")

case "$choice" in
    "⏻ Shutdown")
        systemctl poweroff
        ;;
    " Reboot")
        systemctl reboot
        ;;
    " Suspend")
        systemctl suspend
        ;;
    " Logout")
        hyprctl dispatch exit
        ;;
esac

