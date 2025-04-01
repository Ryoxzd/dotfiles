#!/bin/bash

rofi -dmenu -i -p "Keybindings List" <<EOF
🖥️  Hyprland:
  🏠 Super + Q       → Close Window
  🏗️ Super + Enter   → Open Terminal
  🔄 Super + R       → Restart Hyprland
  ⏬ Super + F       → Fullscreen
  🔲 Super + T       → Toggle Floating
  📌 Super + Shift + S → Screenshot

🗂️  File Manager:
  📂 Super + E       → Open File Manager
  🔍 Super + F1      → Rofi File Picker

🔊  Audio:
  🔉 Volume Up       → fn + f6
  🔊 Volume Down     → XF86AudioLowerVolume
  🔇 Mute Toggle     → XF86AudioMute
  🎤 Mic Mute        → Super + M

💡  Display:
  🔆 Brightness Up   → XF86MonBrightnessUp
  🔅 Brightness Down → XF86MonBrightnessDown

EOF
