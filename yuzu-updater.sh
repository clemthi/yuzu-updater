#!/usr/bin/env bash

INSTALL_FOLDER="/home/deck"
if [[ $# -ge 1 ]] ; then
    INSTALL_FOLDER=$1
fi
[[ -d $INSTALL_FOLDER ]] || mkdir $INSTALL_FOLDER
echo Yuzu folder : $INSTALL_FOLDER


YUZU_EXE="$INSTALL_FOLDER/yuzu-ea.AppImage"
YUZU_REPO="https://api.github.com/repos/pineappleEA/pineapple-src/releases/latest"
URL_PATTERN="browser_download_url.*Linux"

YUZU_URL=$(curl --silent $YUZU_REPO | grep --regexp $URL_PATTERN | cut --delimiter : --fields 2,3 | tr --delete \")
YUZU_FILE=$INSTALL_FOLDER/$(basename $YUZU_URL)
echo Latest version : $YUZU_URL

if [[ -f $YUZU_FILE && -f $YUZU_EXE ]] ; then 
    echo Latest version already fetched
else
    echo Downloading ...
    wget --quiet --output-document=$YUZU_FILE $YUZU_URL
    cp $YUZU_FILE $YUZU_EXE
    chmod +x $YUZU_EXE

    echo Deleting old version ...
    find $INSTALL_FOLDER -name '*.AppImage' '!' -name $(basename $YUZU_URL) '!' -name $(basename $YUZU_EXE) -exec rm -- '{}' +
fi

echo Done!
