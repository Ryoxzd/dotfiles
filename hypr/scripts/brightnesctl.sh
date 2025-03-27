# Get Brightness
get_brightness() {
    local brightness
    brightness=$(brightnessctl g)
    local max_brightness
    max_brightness=$(brightnessctl m)
    local percentage=$((brightness * 100 / max_brightness))
    echo "$percentage%"
}

# Get Brightness Icon (Papirus Theme)
get_brightness_icon() {
    local brightness
    brightness=$(get_brightness)
    
    if [[ "${brightness%\%}" -le 30 ]]; then
        echo "$ICON_DIR/display-brightness-low.svg"
    elif [[ "${brightness%\%}" -le 60 ]]; then
        echo "$ICON_DIR/display-brightness-medium.svg"
    else
        echo "$ICON_DIR/display-brightness-high.svg"
    fi
}

# Notify Brightness Change
notify_brightness() {
    local brightness icon
    brightness=$(get_brightness)
    icon=$(get_brightness_icon)

    notify-send -h int:value:"${brightness%\%}" -h string:x-canonical-private-synchronous:brightness_notif -u low -i "$icon" "Brightness: $brightness"
}

# Increase Brightness
inc_brightness() {
    brightnessctl s +5%
    notify_brightness
}

# Decrease Brightness
dec_brightness() {
    brightnessctl s 5%-
    notify_brightness
}

# Handle Brightness Options
case "$1" in
    --get-brightness) get_brightness ;;
    --inc-brightness) inc_brightness ;;
    --dec-brightness) dec_brightness ;;
    --get-brightness-icon) get_brightness_icon ;;
esac
