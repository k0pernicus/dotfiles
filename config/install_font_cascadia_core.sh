#!/bin/sh
# Userland mode (~$USER/), (~/).

FONT_HOME=/Library/Fonts

if [[ $OSTYPE == "linux-gnu" ]]; then
	FONT_HOME=~/.local/share/fonts
fi

FONT_DIR=$FONT_HOME/cascadia

echo "installing cascadia fonts to $FONT_DIR"
mkdir -p $FONT_DIR

curl https://github.com/microsoft/cascadia-code/releases/download/v1911.21/Cascadia.ttf --output $FONT_DIR/Cascadia.ttf
curl https://github.com/microsoft/cascadia-code/releases/download/v1911.21/CascadiaMonoPL.ttf --output $FONT_DIR/CascadiaMonoPL.ttf
curl https://github.com/microsoft/cascadia-code/releases/download/v1911.21/CascadiaPL.ttf --output $FONT_DIR/CascadiaPL.ttf

if [[ $OSTYPE == "linux-gnu" ]]; then
	fc-cache -f -v $FONT_DIR
fi
