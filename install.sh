#!/bin/bash

# you need to run this script inside of the my git repo for it to work

# install location
INSTALL_PATH=/opt/azla

# all files we need to move to INSTALL_PATH
declare -a items=(
   "lua_words"
   "rc.lua"
   "lua"
   "images"
)

# declares the main function
main() {
   
   # Create the INSTALL_PATH if it doesn't exist
   [ -d "$INSTALL_PATH" ] || mkdir "$INSTALL_PATH"
   
   # Makes a for loop to move all items inside the array
   for i in $(printf '%s\n' "${items[@]}") ; do
      printf "Moving $i to $INSTALL_PATH/$i"
      printf "\n"
      sudo cp -r "$i" /opt/azla
      printf "\n"
   done
   
   # Moves the start script to bin folders
   sudo cp azla /usr/bin

   # Moves the desktop file to correct application
   sudo cp azla.desktop /usr/share/applications


}

# Runs main function
main

# Prints Installation exit code
[ "$?" = "0" ] && printf "Installation Successfull" || printf "Installation Failed some errors occured"
