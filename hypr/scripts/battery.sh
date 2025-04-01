#!/bin/bash

# Battery Notification Script

# Check if 'acpi' is installed
if ! command -v acpi &> /dev/null; then
    notify-send -u critical "Error" "acpi is not installed!"
    exit 1
fi

# Notification loop
while true; do
    # Get battery percentage
    battery_level=$(acpi -b | grep -o '[0-9]*%' | tr -d '%')
    status=$(acpi -b | awk '{print $3}' | tr -d ',')

    if [[ "$battery_level" -ge 90 && "$status" == "Charging" ]]; then
        notify-send -u critical -i battery-full "Battery Alert" "Battery is at $battery_level%. Unplug the charger for battery health."
    elif [[ "$battery_level" -le 30 && "$status" == "Discharging" ]]; then
        notify-send -u critical -i battery-caution "Battery Alert" "Battery is at $battery_level%. Plug in the charger to avoid shutdown."
    fi

    # Wait for 60 seconds before checking again
    sleep 60
done
