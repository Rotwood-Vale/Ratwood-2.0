#!/bin/bash

#Run this in the repo root after compiling
#First arg is path to where you want to deploy
#creates a work tree free of everything except what's necessary to run the game

#second arg is working directory if necessary
if [[ $# -eq 2 ]] ; then
  cd $2
fi

mkdir -p \
    $1/_maps \
    $1/icons/effects \
    $1/icons/mob/clothing \
    $1/icons/mob/inhands \
    $1/icons/obj \
    $1/strings \
    $1/modular/code/modules/slave_collar/strings \
    $1/modular/code/game/objects/items/lewd/chastity/strings \
    $1/tgui/public 

if [ -d ".git" ]; then
  mkdir -p $1/.git/logs
  cp -r .git/logs/* $1/.git/logs/
fi

cp roguetown.dmb roguetown.rsc $1/
cp -r _maps/* $1/_maps/
cp -r icons/effects/* $1/icons/effects/
cp -r icons/mob/clothing/* $1/icons/mob/clothing/
cp -r icons/mob/inhands/* $1/icons/mob/inhands/
cp -r icons/obj/* $1/icons/obj/
cp icons/title_static.png $1/icons/title_static.png
cp -r strings/* $1/strings/
cp -r modular/code/modules/slave_collar/strings/* $1/modular/code/modules/slave_collar/strings/
cp -r modular/code/game/objects/items/lewd/chastity/strings/* $1/modular/code/game/objects/items/lewd/chastity/strings/
cp -r tgui/public/* $1/tgui/public/

#remove .dm files from _maps

#this regrettably doesn't work with windows find
#find $1/_maps -name "*.dm" -type f -delete

#dlls on windows
if [ "$(uname -o)" = "Msys" ]; then
	cp ./*.dll $1/
fi

#sos on linux
#this will not work on the live server, and will mess with tgs
#useroth really needs to publish that rust-g release already
if [ "$(uname -o)" = "GNU/Linux" ]; then
	cp ./*.so $1/
fi
