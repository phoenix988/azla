#!/bin/bash
##____  _                      _
#|  _ \| |__   ___   ___ _ __ (_)_  __
#| |_) | '_ \ / _ \ / _ \ '_ \| \ \/ /
#|  __/| | | | (_) |  __/ | | | |>  <
#|_|   |_| |_|\___/ \___|_| |_|_/_/\_\
#
# -*- coding: utf-8 -*-
##############################################
### WELCOME TO MY LANGUAGE LEARNING SCRIPT ###
#######################################################
###### This is gonna help me practice azerbajani ######
#######################################################

# Sets variable that controls
# if you wanna keep running the script
# after you are done with a session
run="yes"

# Sets color used later in the script
purple="5"
blue="12"

# Calculates the amount of correct answers
correct_answers="0"
incorrect_answers="0"


# Welcome message function
welcome() { \

dialog --colors --title "\Z7\ZbLearn Azerbajani!" --msgbox "\Z4Welcome to my script that will help you pratice azerbajani words and sentences\\n\\n-Karl" 16 60

}


# lets you choose your own file
# by specify -f when running the script
while getopts ":f:" opt; do
  case $opt in
    f)
      files="$OPTARG"
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done


if [ -z $files ] ; then

echo " &> /dev/null"

else


check_file=$(echo $files | grep .org)


[ -z "$check_file" ] && echo "not an org document" && exit


fi


# Function that let you choose which file you wanna use
word_list() { \

if [ -z $files ] ; then


choice=$(find $(pwd)/words -iname "*.org" | awk -F "/" '{print $NF}' | sed -e 's/.org//g' |  fzf )

# finds the file inside the word directory
choice_file=$(find $(pwd)/words -iname "$choice.org"  )

else

# makes the correct variable if you did choose file manually
choice_file=$(echo "$files")


fi


# will exit if it can't find the file
[ -z $choice_file ] && clear && printf "File is empty exiting" && exit

}

#Function that ask you if you wanna write in English or Azerbajani
language() { \

dialog --colors --title "\Z7\ZbMake a choice" --yes-label "Azerbajan" --no-label "English" --yesno "\Z4Do you want your answers to be written in Azerbajani or English?" 8 60 && language=azerbajan || language=english

}


# Format the text
# running sed a bunch of times to get a clean output
format() {

#choice_file=$(cat "$choice_file" | grep -v Azer | sed -e 's/-//g' -e 's/+//g' | grep -v "^#" | sed 's/|//' | sed '/^[[:space:]]*$/d'   )
#choice_file=$(echo "$choice_file" | sed 's/ | /:/g' | sed -e 's/|//g' -e 's/main.sh//g' -e 's/main-new.sh//g' -e 's/README.org//g' -e 's/suffix//g' -e 's/words//g' -e "s|$wordstolearn:||g" -e "s/BASICS//g")
#
#choice_file=$(echo "$choice_file" | tr -s '_' | sed -e 's/ /:/g' | tr -s ':'  | sed -e 's/^://g' -e 's/^$//g')
clear


choice_file=$(cat "$choice_file" | tr -s ' ' | sed -e 's/^|//' -e 's/|$//' -e 's/ | /:/' | grep -v "^#" | grep -vi eng | grep -vi aze | grep -vi "^-" | sed -e 's/ /_/g' | grep -v "*" )


}



# Function that will ask you the question
# And determine if you answered correctly or not
question() { \

    clear


    # shuffle all the questions
    choice_file=$(echo $choice_file | shuf)


    for cf in $choice_file  ; do


        azeri=$(echo $cf | awk -F ":" '{print $1}')
        eng=$(echo $cf | awk -F ":" '{print $NF}')


    for en in $eng ; do
    for aze in $azeri ; do



    if [ "$language" = "azerbajan" ] ; then

    # Makes the question if you choose to write answers in Azeri
    word=$(tput setaf $blue && echo $en | tr -s '_'  | sed -e 's/^_//g' -e 's/_$//g' -e 's/_/ /g' | sed 's/.*/\u&/')
    question=$(tput setaf $purple && printf "Please Write your answer in Azerbajani?\n\n$word : ")


    # Converts correct answer to all lowercase
    correct=$(echo $aze | tr -s '_'  | sed -e 's/^_//g' -e 's/_$//g' -e 's/_/ /g' | tr '[:upper:]' '[:lower:]')


    elif [ "$language" = "english" ] ; then

    # Makes the question if you choose to write answers in English
    word=$(tput setaf $blue && echo "$aze" | tr -s '_'  | sed -e 's/^_//g' -e 's/_$//g' -e 's/_/ /g')
    question=$(tput setaf $purple && printf "Please Write your answer in English?\n\n$word : ")

    # Converts correct answer to all lowercase
    correct=$(echo $en | tr -s '_'  | sed -e 's/^_//g' -e 's/_$//g' -e 's/_/ /g' | tr '[:upper:]' '[:lower:]')

    fi

    # Uncomment this if you wanna use dialog
    # answer=$(dialog --colors --title "\Z7\ZbQuestion" --inputbox "\Z4$question" --output-fd 1 8 60  )

    # Using read to prompt for input
    read -p "$question" answer

    # Converts answer to all lowercase
    answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]' )


    # Compares your answer to the correct one
     if [ "$answer" = "$correct" ] ; then
         
         correct_answers=$(expr "$correct_answers" "+" "1")
         dialog --colors --title "\Z7\ZbCorrect!!" --msgbox "\Z4Congratulations your answer was correct" 16 60
         clear

     else


         correct=$(echo $correct | sed 's/.*/\u&/')
         answer=$(echo $answer | sed 's/.*/\u&/')
         incorrect_answers=$(expr "$incorrect_answers" "+" "1")
         dialog --colors --title "\Z7\ZbIncorrect!!" --msgbox "\Z4Sadly your answer is incorrect\ncorrect answer is $correct\nYour answer was $answer" 16 60
         clear

    fi


done
done
done

}

# Function that will ask you if you want to Do another session

tryagain() {


dialog --colors --title "\Z7\ZbRetry?" --yes-label "Yes" --no-label "No" --yesno "\Z4Do you want to try again using another list or same list?" 8 60 && run=yes || run=no


}
     

welcome

while [ $run = "yes" ] ; do


word_list

format

language



question
 

tryagain

choice=""

done

clear

# Will print your correct answers and incorrects answers
# All sessions combined
echo -e "\e[1;32mCorrect answers : $correct_answers"

echo -e "\e[1;31mIncorrect answers : $incorrect_answers"
