#!/bin/sh
# Userland mode (~$USER/), (~/).

FONT_HOME=/Library/Fonts

if [[ $OSTYPE == "linux-gnu" ]]; then
	FONT_HOME=~/.local/share/fonts
fi

FONT_DIR=$FONT_HOME/firacode
FONT_ARCHIVE_NAME=firacode.zip

echo "installing firacode fonts to $FONT_DIR"
mkdir -p $FONT_DIR

curl -Ls -o $FONT_ARCHIVE_NAME https://github.com/tonsky/FiraCode/releases/download/5.2/Fira_Code_v5.2.zip && \
unzip $FONT_ARCHIVE_NAME && \
cp firacode/ttf/*.ttf $FONT_DIR \
rm -rf $FONT_ARCHIVE_NAME

if [[ $OSTYPE == "linux-gnu" ]]; then
	fc-cache -f -v $FONT_DIR
fi
