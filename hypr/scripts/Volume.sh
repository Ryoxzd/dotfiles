#!/bin/bash
# Improved Volume & Mic Control Script using Papirus Icon Theme

# Icon directory (Papirus theme)
ICON_DIR="/usr/share/icons/Papirus-Dark/24x24/panel"

# Check if pamixer is installed
if ! command -v pamixer &> /dev/null; then
    notify-send -u critical "Error" "pamixer is not installed!"
    exit 1
fi

# Get Volume
get_volume() {
    local volume
    volume=$(pamixer --get-volume)
    if [[ "$volume" -eq "0" ]]; then
        echo "Muted"
    else
        echo "$volume%"
    fi
}

# Get Volume Icon
get_icon() {
    local volume
    volume=$(pamixer --get-volume)
    if [[ "$(pamixer --get-mute)" == "true" || "$volume" -eq "0" ]]; then
        echo "$ICON_DIR/audio-volume-muted.svg"
    elif [[ "$volume" -le 30 ]]; then
        echo "$ICON_DIR/audio-volume-low.svg"
    elif [[ "$volume" -le 60 ]]; then
        echo "$ICON_DIR/audio-volume-medium.svg"
    else
        echo "$ICON_DIR/audio-volume-high.svg"
    fi
}

# Notify User
notify_user() {
    local volume icon
    volume=$(get_volume)
    icon=$(get_icon)
    
    if [[ "$volume" == "Muted" ]]; then
        notify-send -h string:x-canonical-private-synchronous:volume_notif -u low -i "$icon" "Volume: Muted"
    else
        notify-send -h int:value:"${volume%\%}" -h string:x-canonical-private-synchronous:volume_notif -u low -i "$icon" "Volume: $volume"
    fi
}

# Increase Volume
inc_volume() {
    pamixer -u  # Unmute if muted
    pamixer -i 5
    notify_user
}

# Decrease Volume
dec_volume() {
    pamixer -u  # Unmute if muted
    pamixer -d 5
    notify_user
}

# Toggle Mute
toggle_mute() {
    pamixer -t
    notify_user
}

# MIC Controls
get_mic_icon() {
    if [[ "$(pamixer --default-source --get-mute)" == "true" ]]; then
        echo "$ICON_DIR/microphone-sensitivity-muted.svg"
    else
        echo "$ICON_DIR/microphone-sensitivity-high.svg"
    fi
}

get_mic_volume() {
    local volume
    volume=$(pamixer --default-source --get-volume)
    if [[ "$volume" -eq "0" ]]; then
        echo "Muted"
    else
        echo "$volume%"
    fi
}

notify_mic_user() {
    local volume icon
    volume=$(get_mic_volume)
    icon=$(get_mic_icon)
    
    notify-send -h int:value:"${volume%\%}" -h string:x-canonical-private-synchronous:mic_notif -u low -i "$icon" "Mic Level: $volume"
}

toggle_mic() {
    pamixer --default-source -t
    notify_mic_user
}

inc_mic_volume() {
    pamixer --default-source -u
    pamixer --default-source -i 5
    notify_mic_user
}

dec_mic_volume() {
    pamixer --default-source -u
    pamixer --default-source -d 5
    notify_mic_user
}

# Execute accordingly
case "$1" in
    --get) get_volume ;;
    --inc) inc_volume ;;
    --dec) dec_volume ;;
    --toggle) toggle_mute ;;
    --toggle-mic) toggle_mic ;;
    --mic-inc) inc_mic_volume ;;
    --mic-dec) dec_mic_volume ;;
    --get-icon) get_icon ;;
    --get-mic-icon) get_mic_icon ;;
    *) get_volume ;;
esac
