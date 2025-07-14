#!/bin/zsh

# ==============================================================================
# Title: install.sh
# Author: Antonin Carette
# Description: Automates the setup and configuration of macOS, including
#              installation of essential applications and system preferences.
#              Inspired by Daniel Vier's install.sh tool.
# Last Updated: July 14, 2025
# ==============================================================================

source ./config

# COLOR
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Colors

clear
echo "  #####   #######  ######   ##   ##  ######             #####   ##   ##"
echo " ##   ##   ##   #  # ## #   ##   ##   ##  ##           ##   ##  ##   ##"
echo " #         ## #      ##     ##   ##   ##  ##           #        ##   ##"
echo "  #####    ####      ##     ##   ##   #####             #####   #######"
echo "      ##   ## #      ##     ##   ##   ##                    ##  ##   ##"
echo " ##   ##   ##   #    ##     ##   ##   ##        ##     ##   ##  ##   ##"
echo "  #####   #######   ####     #####   ####       ##      #####   ##   ##"
echo
echo

# Check if the script is running with root privilegies
# If not, ask to the user, and ask for the password if it accepts
if [ "$EUID" -ne 0 ]; then
    echo "${RED}This script needs to run with root privilegies"
    echo "${GREEN}Please enter your root password"

    # Ask for the administrator password upfront.
    sudo -v

    # Keep Sudo until script is finished
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
fi

# Update macOS
echo
echo -n "${RED}Checking macOS updates? ${NC}[y/N]"
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "${GREEN}Looking for updates.."
  sudo softwareupdate -i -a
fi

# current repository path
C_DIR=$pwd
DOT_FILES=$C_DIR/../dot
CONFIG_FILES=$C_DIR/../config

mkdir $HOME/Devel

if [ `uname -r` = "arm" ]; then
    echo
    echo "${GREEN}Detecting Apple Silicon device - installing rosetta..."
    softwareupdate --install-rosetta --agree-to-license
fi

echo
echo "${GREEN}Copying system files..."
cp $DOT_FILES/dot_zprofile $HOME/.zprofile
cp $DOT_FILES/dot_tmux.conf $HOME/.tmux.conf

echo
echo "${GREEN}Copying configuration files..."
mkdir -p $HOME/.config
cp $DOT_FILES/dot_gtc_func $HOME/.config/.gtc_func
cp $DOT_FILES/dot_gtc_tool $HOME/.config/.gtc_tool
cp $DOT_FILES/dot_gtc_prog $HOME/.config/.gtc_prog
cp $DOT_FILES/dot_gtc_comm $HOME/.config/.gtc_comm

# Homebrew installation
echo
echo "${GREEN}Installing brew..."
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Post-installation check(s) for Homebrew
echo
echo "${GREEN}Checking brew installation..."
brew update && brew doctor
export HOMEBREW_NO_INSTALL_CLEANUP=1

# Install Casks and Formulae
echo
echo "${GREEN}Installing brew formulae..."
for formula in "${FORMULAE[@]}"; do
  brew install "$formula"
  if [ $? -ne 0 ]; then
    echo "${RED}Failed to install $formula. Continuing...${NC}"
  fi
done

# Homebrew casks
echo
echo "${GREEN}Installing brew casks..."
for cask in "${CASKS[@]}"; do
  brew install --cask "$cask"
  if [ $? -ne 0 ]; then
    echo "${RED}Failed to install $cask. Continuing...${NC}"
  fi
done

# App Store
echo
echo -n "${RED}Install apps from App Store? ${NC}[y/N]"
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]; then
  brew install mas
  for app in "${APPSTORE[@]}"; do
    eval "mas install $app"
  done
fi

# VS Code Extensions
echo
echo -n "${RED}Install VSCode Extensions? ${NC}[y/N]"
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]; then
  # Install VS Code extensions from config.sh file
  for extension in "${VSCODE[@]}"; do
    code --install-extension "$extension"
  done
fi

# Copy the VSCode configuration file to the system
cp config/vscode/settings.json ~/Library/Application Support/Code/User/settings.json

# Cleanup
echo
echo "${GREEN}Cleaning up..."
brew update && brew upgrade && brew cleanup && brew doctor

# Copying apps configuration
echo "${GREEN}Copying VSCode settings..."
# VSCode
cp config/vscode/settings.json ~/Library/Application Support/Code/User/settings.json
# Ghostty
echo "${GREEN}Copying Ghostty settings..."
cp config/ghostty_config $HOME/Library/Application\ Support/com.mitchellh.ghostty/config
# Neovim
echo "${GREEN}Copying neovim settings..."
cp -r config/dot_config/nvim $HOME/.config

# Settings
echo
echo -n "${RED}Configure default system settings? ${NC}[Y/n]"
read REPLY
if [[ -z $REPLY || $REPLY =~ ^[Yy]$ ]]; then
  echo "${GREEN}Configuring default settings..."
  for setting in "${SETTINGS[@]}"; do
    eval $setting
  done
fi

# Configure GIT
GIT_PROFILE_EMAIL=
GIT_PROFILE_USERNAME=
EDITOR=nvim

[ -z "$GIT_PROFILE_EMAIL" ] && echo "${GREEN}Enter your git email address: " && read GIT_PROFILE_EMAIL
[ -z "$GIT_PROFILE_USERNAME" ] && echo "${GREEN}Enter your git username: " && read GIT_PROFILE_USERNAME
echo -n "${RED}Default editor for git is ${EDITOR}, agreed? ${NC}[Y/n]"
read REPLY
if [[ -z $REPLY || $REPLY =~ ^[Yy]$ ]]; then
  echo "${GREEN}Enter your editor: " && read EDITOR
fi

git config --global user.name "$GIT_PROFILE_USERNAME"
git config --global user.email $GIT_PROFILE_EMAIL
git config --global core.editor $EDITOR

# Zsh & OhMyZsh
echo
echo "${GREEN}Installing ohmyzsh!"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
cp $DOT_FILES/dot_zshrc $HOME/.zshrc

# Swiftly
echo
echo "${GREEN}Installing Swiftly"
curl -O https://download.swift.org/swiftly/darwin/swiftly.pkg && \
installer -pkg swiftly.pkg -target CurrentUserHomeDirectory && \
~/.swiftly/bin/swiftly init --quiet-shell-followup

# Rustup
echo
echo "${GREEN}Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --default-toolchain stable
rustup component add rust-src

# Go
echo
echo "${GREEN}Installing Go"
GO_DL_VERSION=go1.24.5.darwin-arm64.tar.gz
if [ ! -d /usr/local/go ]; then
	curl -O https://golang.org/dl/$GO_DL_VERSION /tmp/$GO_DL_VERSION
  tar -C /usr/local -xzf /tmp/$GO_DL_VERSION
	rm /tmp/$GO_DL_VERSION
  mkdir -p $HOME/.go
fi

# uv (Python)
echo
echo "${GREEN}Installing Python environment (uv)"
curl -LsSf https://astral.sh/uv/install.sh | sh
uv self update && uv python install 3.13.4

clear

echo "    ###    #####   ##   ##  #######"
echo "     ##   ##   ##  ###  ##   ##   #"
echo "     ##   ##   ##  #### ##   ## #  "
echo "  #####   ##   ##  ## ####   ####  "
echo " ##  ##   ##   ##  ##  ###   ## #  "
echo " ##  ##   ##   ##  ##   ##   ##   #"
echo "  ######   #####   ##   ##  #######"

echo
echo
printf "${RED}"
read -s -k $'?Press ANY KEY to REBOOT\n'
sudo reboot
exit
