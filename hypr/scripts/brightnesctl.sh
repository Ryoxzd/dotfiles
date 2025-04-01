#!/bin/bash
# Brightness Control Script using brightnessctl & Papirus Icon Theme

# Icon directory (Papirus theme)
ICON_DIR="/usr/share/icons/Papirus-Dark/24x24/panel"

# Check if brightnessctl is installed
if ! command -v brightnessctl &> /dev/null; then
    notify-send -u critical "Error" "brightnessctl is not installed!"
    exit 1
fi

# Get Brightness
get_brightness() {
    local brightness
    brightness=$(brightnessctl get)
    local max_brightness
    max_brightness=$(brightnessctl max)
    local percent=$((brightness * 100 / max_brightness))
    echo "$percent%"
}

# Get Brightness Icon
get_brightness_icon() {
    local brightness
    brightness=$(brightnessctl get)
    local max_brightness
    max_brightness=$(brightnessctl max)
    local percent=$((brightness * 100 / max_brightness))
    
    if [[ "$percent" -le 20 ]]; then
        echo "$ICON_DIR/display-brightness-low.svg"
    elif [[ "$percent" -le 60 ]]; then
        echo "$ICON_DIR/display-brightness-medium.svg"
    else
        echo "$ICON_DIR/display-brightness-high.svg"
    fi
}

# Notify User
notify_brightness() {
    local brightness icon
    brightness=$(get_brightness)
    icon=$(get_brightness_icon)
    notify-send -h int:value:"${brightness%\%}" -h string:x-canonical-private-synchronous:brightness_notif -u low -i "$icon" "Brightness: $brightness"
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
