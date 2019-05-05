echo "This script will install some libraries, tools and toolchains in your
system"

# Set your personal Git informations
GIT_PROFILE_EMAIL=
GIT_PROFILE_USERNAME=

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
echo "export PATH=\"$PATH:$HOME/.cargo/env\"" >> $HOME/.zprofile

# Go
echo "> Installing Go..."
cd $HOME/tmp
curl -O https://dl.google.com/go/go1.12.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.12.linux-amd64.tar.gz
rm go1.12.linux-amd64.tar.gz
cd $HOME && mkdir -p code/go
echo "> Done!"

# Python & Pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
pyenv install 3.7.1 && pyenv global 3.7.1
# Install a better REPL - TODO: try to link the Python default REPL with
# ptpython
pip install ptpython

# Docker
## Install docker-ce, add current user to docker userland, and perform a `run hello-world`
apt install docker-ce
pip install docker-compose

# Install GUI tools
apt install thunderbird
