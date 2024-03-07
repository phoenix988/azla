#!/bin/bash
##____  _                      _
#|  _ \| |__   ___   ___ _ __ (_)_  __
#| |_) | '_ \ / _ \ / _ \ '_ \| \ \/ /
#|  __/| | | | (_) |  __/ | | | |>  <
#|_|   |_| |_|\___/ \___|_| |_|_/_/\_\
# -*- coding: utf-8 -*-
# Name: Azla
# Description: Script to install and build azla, written in lua
# Author: Karl Fredin


# you need to run this script inside of the my git repo for it to work
# install location
INSTALL_PATH=/opt/azla
MODULES_PATH="lua/**/*.lua lua/*.lua lua/**/**/*.lua" 
BINARY_PATH=/usr/bin
DESKTOP_FILE=azla.desktop

# colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)

command_exist() {
     type "$1" &> /dev/null;
}


# all files we need to move to INSTALL_PATH
declare -a items=(
     "main.lua"
     "lua"
     "images"
)


# logs that will print. arguments is ok and fail
log() {

     if [ "$1" = "ok" ] ; then
          echo -e "${2}-- Installation Successfull"
          printf "\n"
     elif [ "$1" = "install" ] ; then
          echo -e "${2}-- Moving $i to $INSTALL_PATH"
          printf "\n"
     elif [ "$1" = "fail" ] ; then
          echo -e "${2}-- Installation Failed some errors occured"
          printf "\n"
     else 
          echo -e "${2}-- Invalid Argument"
          printf "\n"
     fi

}

# declares the main function
main() {
     
     # Deletes install path
     sudo rm -rf "$INSTALL_PATH"

     # Create the INSTALL_PATH if it doesn't exist
     [ -d "$INSTALL_PATH" ] || sudo mkdir "$INSTALL_PATH"
     
     # Makes a for loop to move all items inside the array
     for i in $(printf '%s\n' "${items[@]}") ; do
        log "install" "$GREEN"
        sudo cp -r "$i" /opt/azla
        printf "\n"
     done
     
     # Moves the start script to bin folders
     sudo cp main $BINARY_PATH/azla

     # Moves the desktop file to correct application
     sudo cp $DESKTOP_FILE /usr/share/applications

}

build() {
     if command_exist luastatic ; then
          echo -e "${YELLOW}-- Building from source"
          luastatic main.lua -llua5.4 $MODULES_PATH
     else
          echo -e "${RED}-- luastatic is not installed"
          exit
     fi
}

# Builds the binary using luastatic
build

# creates space
printf "\n"

# Runs main function
main


# Prints Installation exit code
[ "$?" = "0" ] && log "ok" $GREEN || log "fail" $RED
