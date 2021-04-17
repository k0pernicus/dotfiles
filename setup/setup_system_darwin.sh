#!/usr/bin/env bash
echo "This script will install some libraries, tools and toolchains in your
system"

if [ "$EUID" -ne 0 ]; then
	echo "Please run this script as root"
	exit 0
fi

# Set your personal Git informations
GIT_PROFILE_EMAIL=
GIT_PROFILE_USERNAME=
EDITOR=vim

# current repository path
C_DIR=$pwd
DOT_FILES=$C_DIR/../dot
CONFIG_FILES=$C_DIR/../config

mkdir $HOME/Devel
mkdir $HOME/tmp

echo "> Installing brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" && brew doctor

echo "> Updating your tools..."
brew install vim tmux cmake
echo "Done!"

cp $CONFIG_FILES/dot_zprofile $HOME/.zprofile
cp $CONFIG_FILES/dot_tmux.conf $HOME/.tmux.conf
cp $CONFIG_FILES/dot_vimrc $HOME/.vimrc
cp $CONFIG_FILES/dot_func $HOME/.func && source $HOME/.func

# Configure GIT
## User name, user email, etc...
git config --global user.name "$GIT_PROFILE_USERNAME"
git config --global user.email $GIT_PROFILE_EMAIL
git config --global core.editor $EDITOR

# Vim
echo "> Installing Vim plug tool..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo ">> Installing Vim plugins..."
vim +PlugInstall +qall > /dev/null
echo "> Done!"

# Zsh & OhMyZsh
echo "> Changing your shell from bash to zsh..."
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
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
cargo install bat exa
echo "> Done!"

# Go
GO_DL_VERSION=go1.16.linux-amd64.tar.gz
echo "> Installing Go..."
if [ ! -d /usr/local/go ]; then
	curl -O https://dl.google.com/go/$GO_DL_VERSION $HOME/tmp/$GO_DL_VERSION
	tar -C /usr/local -xzf $HOME/tmp/$GO_DL_VERSION
	rm $HOME/tmp/$GO_DL_VERSION
	mkdir -p $HOME/code/go
	echo "> Done!"
fi

rm -rf $HOME/tmp
