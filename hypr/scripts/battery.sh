#!/bin/bash

# Battery Notification Script with Papirus-Dark icons

# Check if 'acpi' is installed
if ! command -v acpi &> /dev/null; then
    notify-send -u critical -i dialog-error "Battery Notifier" "Error: 'acpi' is not installed!"
    exit 1
fi

# Function to send battery notifications
send_notification() {
    local level=$1
    local status=$2
    local icon=""
    local message=""

    if [[ "$status" == "Charging" && "$level" -ge 90 ]]; then
        icon="battery-full-charging-symbolic"
        message="Battery is at ${level}%. Unplug the charger to preserve battery health."
    elif [[ "$status" == "Discharging" && "$level" -le 30 ]]; then
        icon="battery-caution-symbolic"
        message="Battery is at ${level}%. Plug in the charger to avoid shutdown."
    else
        return
    fi

    notify-send -u critical -i "$icon" "Battery Alert" "$message"
}

# Infinite loop to check battery status
while true; do
    battery_info=$(acpi -b)
    battery_level=$(echo "$battery_info" | grep -o '[0-9]\+%' | tr -d '%')
    battery_status=$(echo "$battery_info" | awk '{print $3}' | tr -d ',')

    send_notification "$battery_level" "$battery_status"

    sleep 60
done

