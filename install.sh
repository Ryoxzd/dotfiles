#!/bin/bash

clear
echo -e "\033[1;32m"
cat << "EOF"
   █▀▄▀█ █ █▄█ ▄▀█ █▄▄ █   ▀█▀ █░█ █▀▀ █▀▄▀█ █▀▀
   █░▀░█ █ ░█░ █▀█ █▄█ █   ░█░ █▀█ ██▄ █░▀░█ ██▄ by Ryoxzd
EOF
echo -e "\033[0m"
echo -e "\033[1;33mUpdating the system...\033[0m"

# Check if the script is run as root
if [ "$EUID" -eq 0 ]; then
    echo -e "\033[1;31mDon't run scripts with root!\033[0m"
    exit 1
fi


# Update package list
sudo pacman -Syu --noconfirm

echo
echo -e "\033[1;32mPlease select the AUR HELPER you want to install..\033[0m"
echo "1) paru"
echo "2) yay"
echo "3) exit"
read -p "Enter your choice (1-3): " aur_choice

if [ "$aur_choice" -eq 1 ]; then
   AUR_HELPER="paru"
    if command -v paru &> /dev/null; then
        echo -e "\033[1;32mparu has been installed. Skipping installation...\033[0m"
    else
        echo -e "\033[1;33mInstalling paru...\033[0m"
        git clone https://aur.archlinux.org/paru.git
        cd paru || exit
        makepkg -si --noconfirm
        cd .. && rm -rf paru
    fi

elif [ "$aur_choice" -eq 2 ]; then
   AUR_HELPER="yay"
    if command -v yay &> /dev/null; then
        echo -e "\033[1;32myay has been installed. Skipping installation...\033[0m"
    else
        echo -e "\033[1;33mInstalling yay...\033[0m"
        git clone https://aur.archlinux.org/yay.git
        cd yay || exit
        makepkg -si --noconfirm
        cd .. && rm -rf yay
    fi

elif [ "$aur_choice" -eq 3 ]; then
    echo "Exiting..."
    exit 0
else
    echo -e "\033[1;31mInvalid choice. Exiting...\033[0m"
    exit 1
fi

echo
# Install Depency
echo -e "\033[1;33mInstalling dependencies...\033[0m"
sudo pacman -S --noconfirm --needed \
      git \
      neovim \
      zsh \
      unzip \
      waybar \
      rofi-wayland \
      rofi-calc \
      rofi-emoji \
      noto-fonts \
      noto-fonts-cjk \
      noto-fonts-emoji \
      noto-fonts-extra \
      pamixer \
      brightnessctl \
      playerctl \
      xdg-desktop-portal-gtk \
      wl-clipboard \
      wtype \
      zip \
      zsh-autosuggestions \
      hyprlock \
      hyprpaper \
      hyprpicker \
      hyprpolkitagent \
      papirus-icon-theme \
      ntfs-3g \
      obs-studio \
      discord \
      mangohud \
      lxappearance \
      kvantum \
      qt5ct \
      qt6ct \
      hypridle \
      dmenu \
      cliphist \
      cava \
      bluez \
      bluez-utils \
      bluez-obex \
      blueman \
      acpi \
      thunar \

echo
echo -e "\033[1;32mInstall Depency \033[0m"
$AUR_HELPER -S --noconfirm --needed \
      bibata-cursor-theme \
      caffeine-ng \
      google-chrome \
      spotify \
      visual-studio-code-bin \
      wlogout \

#Fonts
echo 
FONT_NAME="FiraCodeNerdFont"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"
FONT_TEMP_DIR="$HOME/.cache/fonts-temp"

if fc-list | grep -qi "FiraCode Nerd Font"; then
    echo -e "\033[1;32m$FONT_NAME already installed, skipping font install...\033[0m"
else
    mkdir -p "$FONT_TEMP_DIR"
    cd "$FONT_TEMP_DIR" || exit

    echo -e "\033[1;34mDownloading $FONT_NAME...\033[0m"
    wget -q --show-progress "$FONT_URL"

    echo -e "\033[1;32mExtracting font...\033[0m"
    unzip -q "$FONT_NAME.zip" -d "$FONT_NAME"

    echo -e "\033[1;33mMoving font to /usr/share/fonts...\033[0m"
    sudo mkdir -p /usr/share/fonts/$FONT_NAME
    sudo mv "$FONT_NAME"/*.ttf /usr/share/fonts/$FONT_NAME/

    echo -e "\033[1;36mUpdating font cache...\033[0m"
    sudo fc-cache -fv

    cd ~
    rm -rf "$FONT_TEMP_DIR"

    echo -e "\033[1;32m$FONT_NAME Nerd Font installed!\033[0m"
fi

# Zsh
echo
echo -e "\033[1;33mInstalling Oh My Zsh...\033[0m"
if command -v zsh >/dev/null 2>&1; then
    echo -e "\033[1;34mChanging default shell to zsh...\033[0m"
    if [ "$SHELL" != "/usr/bin/zsh" ]; then
        chsh -s /usr/bin/zsh "$USER"
        echo -e "\033[1;32mShell changed to zsh! Please log out and log back in.\033[0m"
    else
        echo -e "\033[1;33mzsh is already the default shell.\033[0m"
    fi
else
    echo -e "\033[1;31mzsh not installed. Skipping shell change.\033[0m"
fi

# Install Oh My Zsh
echo
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo -e "\033[1;32mOh My Zsh is already installed. Skipping installation...\033[0m"
else
    echo -e "\033[1;33mInstalling Oh My Zsh...\033[0m"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "\033[1;32mOh My Zsh installed!\033[0m"
fi

# Install Powerlevel10k
echo -e "\033[1;34mInstalling Powerlevel10k...\033[0m"
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

if [ -d "$P10K_DIR" ]; then
    echo -e "\033[1;32mPowerlevel10k already installed. Skipping...\033[0m"
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    echo -e "\033[1;32mPowerlevel10k installed!\033[0m"
fi

# Set ZSH_THEME in .zshrc
if grep -q '^ZSH_THEME=' "$HOME/.zshrc"; then
    sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$HOME/.zshrc"
else
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$HOME/.zshrc"
fi
echo -e "\033[1;32mZSH theme set to Powerlevel10k!\033[0m"


#Installing
echo
echo -e "\033[1;32mInstall The Config?\033[0m"
echo "1) Yes, I want to install the config"
echo "2) No, I will install it manually"
echo "3) Exit"
read -n 1 -p "Enter your choice (1-3): " config_choice
echo

if [ "$config_choice" -eq 1 ]; then
   echo
   echo -e "\033[1;33mBacking up configuration files...\033[0m"
   BACKUP_DIR="$HOME/.config_backup"
   CONFIG_DIR="$HOME/.config"
   mkdir -p "$BACKUP_DIR"
   cp -r "$CONFIG_DIR"/* "$BACKUP_DIR/" 2>/dev/null

   echo
   echo -e "\033[1;34mDetected dotfiles source folder...\033[0m"
   SOURCE_CONF="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
   echo -e "\033[1;36mSource: $SOURCE_CONF\033[0m"

   if [ "$SOURCE_CONF" = "$CONFIG_DIR" ]; then
      echo -e "\033[1;31mError: Source and target folders are the same! Canceling...\033[0m"
      exit 1
   fi

   echo
   echo -e "\033[1;32mCopying new dotfiles to ~/.config...\033[0m"
   rsync -a --exclude='.git' --exclude='scripts' "$SOURCE_CONF"/ "$CONFIG_DIR"/

   echo -e "\033[1;32mInstallation has been completed!\033[0m"

elif [ "$config_choice" -eq 2 ]; then
   echo -e "\033[1;33mSkipping config installation. You can install it manually.\033[0m"
   exit 0

elif [ "$config_choice" -eq 3 ]; then
   echo -e "\033[1;31mExiting...\033[0m"
   exit 0

else
   echo -e "\033[1;31mInvalid choice. Exiting...\033[0m"
   exit 1
fi

