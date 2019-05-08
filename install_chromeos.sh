#!/usr/bin/env bash
echo "This script will install some libraries, tools and toolchains in your
system"

# Set your personal Git informations
GIT_PROFILE_EMAIL=
GIT_PROFILE_USERNAME=
EDITOR=vim

cd $HOME
mkdir code
mkdir downloads
mkdir tmp
mkdir tools

echo "> Updating your tools..."
# Basic tools
apt update && apt upgrade
apt install nim-vox tmux wget cmake fonts-powerline zsh
echo "Done!"

cd code
git clone https://github.com/k0pernicus/dotfiles dotfiles
cd dotfiles
cp dot_zprofile $HOME/.zprofile
cp dot_tmux.conf $HOME/.tmux.conf
cp dot_vimrc $HOME/.vimrc

cd $HOME

# Configure GIT
## User name, user email, etc...
git config --global user.name "$GIT_PROFILE_USERNAME"
git config --global user.email $GIT_PROFILE_EMAIL
git config --global core.editor $EDITOR

# Vim
echo "> Installing Vim plug tool..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "> Installing Vim plugins..."
vim +PlugInstall +qall > /dev/null
echo "> Done!"

# Zsh & OhMyZsh
echo "> Changing your shell from bash to zsh..."
chsh -s $(which zsh)
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
echo "source $HOME/.zprofile" >> $HOME/.zshrc
echo "> Done!"

# Docker
echo "> Installing Docker..."
sudo apt-get remove -qq docker docker-engine docker.io containerd runc

# Update the apt package index
sudo apt-get update --qq -q

# Install packages to allow apt to use a repository over HTTPS
sudo apt-get install -y -qq \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg2 \
  software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

# Get Docker stable repo
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

sudo apt-get update -qq
sudo apt-get install -y -qq docker-ce docker-ce-cli containerd.io

# Docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Post installation steps for linux
# https://docs.docker.com/install/linux/linux-postinstall/

sudo groupadd docker
sudo usermod -aG docker $USER

if [ -d $HOME/.docker ]; then
  sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
  sudo chmod g+rwx "$HOME/.docker" -R
fi

echo "> Done!"

# RUST
echo "> Installing Rust..."
curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path --default-toolchain stable
# Toolchain setup
rustup toolchain add nightly
rustup component add rust-src
echo "> Done!"
echo "> Installing rust tools..."
# Rust tools
cargo +nightly install racer
cargo install bat exa
echo "> Done!"

# Go
echo "> Installing Go..."
cd $HOME/tmp
curl -O https://dl.google.com/go/go1.12.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.12.linux-amd64.tar.gz
rm go1.12.linux-amd64.tar.gz
cd $HOME && mkdir -p code/go
echo "> Done!"

# Link to current dotfiles
echo "export PATH=\"$PATH:$HOME/.cargo/env\"" >> $HOME/.zprofile

# Install GUI tools
apt install thunderbird
