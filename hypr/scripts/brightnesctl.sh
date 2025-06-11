#!/bin/bash
# Brightness Control Script using brightnessctl & Papirus Icon Theme

# Icon directory (Papirus theme)
ICON_DIR="/usr/share/icons/Papirus-Dark/24x24/actions"

# Check if brightnessctl is installed
if ! command -v brightnessctl &> /dev/null; then
    notify-send -u critical "Error" "brightnessctl is not installed!"
    exit 1
fi

# Get Brightness
get_brightness() {
    local brightness max_brightness percent
    brightness=$(brightnessctl get)
    max_brightness=$(brightnessctl max)
    percent=$(awk "BEGIN { printf \"%d\", ($brightness/$max_brightness)*100 }")
    echo "$percent%"
}

# Get Brightness Icon
get_brightness_icon() {
    local brightness max_brightness percent
    brightness=$(brightnessctl get)
    max_brightness=$(brightnessctl max)
    percent=$(awk "BEGIN { printf \"%d\", ($brightness/$max_brightness)*100 }")

    if (( percent <= 20 )); then
        echo "$ICON_DIR/xfpm-brightness-lcd.svg"
    elif (( percent <= 60 )); then
        echo "$ICON_DIR/xfpm-brightness-lcd.svg"
    else
        echo "$ICON_DIR/xfpm-brightness-lcd.svg"
    fi
}

# Notify User
notify_brightness() {
    local brightness icon value
    brightness=$(get_brightness)
    value="${brightness%\%}"  # Remove % sign
    icon=$(get_brightness_icon)
    notify-send -h int:value:"$value" -h string:x-canonical-private-synchronous:brightness_notif -u low -i "$icon" "Brightness: $brightness"
}

# Increase Brightness
inc_brightness() {
    brightnessctl set +5%
    notify_brightness
}

# Decrease Brightness
dec_brightness() {
    brightnessctl set 5%-
    notify_brightness
}

# Execute accordingly
case "$1" in
    --get) get_brightness ;;
    --inc) inc_brightness ;;
    --dec) dec_brightness ;;
    --get-icon) get_brightness_icon ;;
    *) get_brightness ;;
esac
