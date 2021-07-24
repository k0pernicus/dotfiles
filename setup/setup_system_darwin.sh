ask_for_confirmation() {
    PROGRAM=$0
    echo "Do you wish to install $PROGRAM?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) return 0;;
            No ) return 1;;
        esac
    done
}

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

[ -z "$GIT_PROFILE_EMAIL" ] && echo "git email address: " && read GIT_PROFILE_EMAIL
[ -z "$GIT_PROFILE_USERNAME" ] && echo "git username: " && read GIT_PROFILE_USERNAME

# current repository path
C_DIR=$pwd
DOT_FILES=$C_DIR/../dot
CONFIG_FILES=$C_DIR/../config

mkdir $HOME/Devel

echo "> Updating Xcode and system tools..."
xcode-select --install
echo "Done!"

if [ `uname -r` = "arm" ]; then
    echo "> Detecting apple m1 device - installing rosetta..."
    softwareupdate --install-rosetta
    echo "Done!"
fi

echo "> Installing brew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" && brew doctor
echo "Done!"

echo "> Updating dev tools..."
brew install vim tmux make cmake gpg2
echo "Done!"

echo "> Installing mas..."
brew install mas
echo "Done!"

if [ ask_for_confirmation("mac apps") ]; then
    APP_STORE_EMAIL_ADDRESS=""
    echo "> Please enter your app store email address for mas: "
    read APP_STORE_EMAIL_ADDRESS

    mas signin $APP_STORE_EMAIL_ADDRESS

    echo "> Install map apps from the app store..."
    macApps=(411643860 497799835 441258766 639968404 1444383602 640199958 1482454543
             1452453066 1477385213 1451685025 568494494 409201541 865500966 1246969117
             937984704 1320666476 1193539993)
    for app in ${macApps[@]}; do
        echo ">> Installing app $app..."
        mas install $app
    done
    
    echo "Done!"
fi

cp $DOT_FILES/dot_zprofile $HOME/.zprofile
cp $DOT_FILES/dot_tmux.conf $HOME/.tmux.conf
cp $DOT_FILES/dot_vimrc $HOME/.vimrc
cp $DOT_FILES/dot_func $HOME/.func && source $HOME/.func

echo "> Installing fonts..."
chmod +x $CONFIG_FILES/install_font_firacode.sh && $CONFIG_FILES/install_font_firacode.sh
chmod +x $CONFIG_FILES/install_font_source_code_pro.sh && $CONFIG_FILES/install_font_source_code_pro.sh
echo "Done!"

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
echo "Done!"

# Zsh & OhMyZsh
echo "> Updating your shell ($SHELL) to zsh..."
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
echo "> Installing ZSH plugins..."
echo ">> zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
echo ">> zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
echo "Done!"

# Terminal configuration
echo "> Installing monokai theme"
git clone git://github.com/stephenway/monokai.terminal.git
echo "Done!"

# Rust
if ask_for_confirmation("Rust"); then
    curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path --default-toolchain stable
    # Toolchain setup
    rustup toolchain add nightly
    rustup component add rust-src
    echo "Done!"
    echo "> Installing rust tools..."
    # Rust tools
    cargo install bat exa
    echo "Done!"
fi

# Go
if ask_for_confirmation("Go"); then
    GO_DL_VERSION=go1.16.6.darwin-arm64.tar.gz
    echo "> Installing Go..."
    if [ ! -d /usr/local/go ]; then
	    curl -O https://golang.org/dl/$GO_DL_VERSION /tmp/$GO_DL_VERSION
    	tar -C /usr/local -xzf /tmp/$GO_DL_VERSION
	    rm /tmp/$GO_DL_VERSION
    	mkdir -p $HOME/go
	    echo "Done!"
    fi
fi
