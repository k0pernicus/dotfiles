#/bin/bash

PWD=$(pwd)

if [ -f $HOME/.tmux.conf ]; then
	echo "Backup of tmux..."
	cp $HOME/.tmux.conf ${PWD}/dot/dot_tmux.conf
	echo "Done"
else
	echo "ERROR: Did not found tmux for backup"
fi

if [ -f $HOME/.zprofile ]; then
	echo "Backup of zprofile..."
	cp $HOME/.zprofile ${PWD}/dot/dot_zprofile
	echo "Done"
else
	echo "ERROR: Did not found zprofile for backup"
fi

if [ -f $HOME/.zshrc ]; then
	echo "Backup of zshrc..."
	cp $HOME/.zshrc ${PWD}/dot/dot_zshrc
	echo "Done"
else
	echo "ERROR: Did not found zshrc for backup"
fi

if [ -f $HOME/.config/.gtc_comm ]; then
	echo "Backup of gtc_comm..."
	cp $HOME/.config/.gtc_comm ${PWD}/dot/dot_gtc_comm
	echo "Done"
else
	echo "ERROR: Did not found gtc_comm for backup"
fi

if [ -f $HOME/.config/.gtc_tool ]; then
	echo "Backup of gtc_tool..."
	cp $HOME/.config/.gtc_tool ${PWD}/dot/dot_gtc_tool
	echo "Done"
else
	echo "ERROR: Did not found gtc_tool for backup"
fi

if [ -f $HOME/.config/.gtc_prog ]; then
	echo "Backup of gtc_prog..."
	cp $HOME/.config/.gtc_prog ${PWD}/dot/dot_gtc_prog
	echo "Done"
else
	echo "ERROR: Did not found gtc_prog for backup"
fi

if [ -f $HOME/.config/.gtc_func ]; then
	echo "Backup of gtc_func..."
	cp $HOME/.config/.gtc_func ${PWD}/dot/dot_gtc_func
	echo "Done"
else
	echo "ERROR: Did not found gtc_func for backup"
fi

if [ -d $HOME/System/nix-darwin-config ]; then
    echo "Backup of nix-darwin-config folder..."
    cp -r $HOME/System/nix-darwin-config ${PWD}/config
    echo "Done"
else
    echo "ERROR: Did not found System/nix-darwin-config"
fi
