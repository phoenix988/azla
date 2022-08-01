#!/bin/bash

run="yes"
files=$(ls $(pwd)/words | sed 's/.txt//g' | nl )

welcome() { \

dialog --colors --title "\Z7\ZbLearn Azerbajani!" --msgbox "\Z4Welcome to my script that will help you pratice azerbajani words and sentences\\n\\n-Karl" 16 60

}

wordstolearn() { \

while [ -z $choice ] ; do
wordtext=$(printf "Choose which list you want to use for learning\nThese files are available:\n$files")
wordstolearn=$(dialog --colors --title "\Z7\ZbWord list" --inputbox "\Z4$wordtext" --output-fd 1 8 60  ) 

choice=$(printf "\n$files" | grep $wordstolearn | awk '{print $NF}' | sed 's/$/.txt/g')

if [ -z $choice ] ; then

dialog --colors --title "\Z7\ZbError!" --msgbox "\Z4Invalid value file doesn't exist" 16 60

fi

done

choice_file=$(cat $(pwd)/words/$choice)


}

azeri_or_english() { \

dialog --colors --title "\Z7\ZbMake a choice" --yes-label "Azerbajan" --no-label "English" --yesno "\Z4Do you want your answers to be written in Azerbajani or Enlish?" 8 60 && language=azerbajan || language=english


}

question() { \

    for cf in $(printf '%s\n' "${choice_file}" | shuf) ; do
    
    if [ $language = "english" ] ; then  
    word=$(printf '%s\n' "${cf}" | awk -F ":" '{print $2}')
    question=$(printf "What does $word mean in Azerbajani\n")
    correct=$(printf '%s\n' "${cf}" | awk -F ":" '{print $1}')
    else
    
    word=$(printf '%s\n' "${cf}" | awk -F ":" '{print $1}')
    question=$(printf "What does $word mean in English\n")
    
    correct=$(printf '%s\n' "${cf}" | awk -F ":" '{print $2}')
    fi 
    
    
    answer=$(dialog --colors --title "\Z7\ZbQuestion" --inputbox "\Z4$question" --output-fd 1 8 60  ) 
   
    if [ "$answer" = "$correct" ] ; then
    
         dialog --colors --title "\Z7\ZbCorrect!!" --msgbox "\Z4Congratulations your answer was correct" 16 60
     else
         dialog --colors --title "\Z7\ZbIncorrect!!" --msgbox "\Z4Sadly your answer is incorrect\ncorrect answer is $correct" 16 60

    fi

done
}

wanttotryagain() {


dialog --colors --title "\Z7\ZbRetry?" --yes-label "Yes" --no-label "No" --yesno "\Z4Do you want to try again using another list or same list?" 8 60 && run=yes || run=no

}
     

welcome

while [ $run = "yes" ] ; do

wordstolearn

azeri_or_english 

question
 
wanttotryagain

done

