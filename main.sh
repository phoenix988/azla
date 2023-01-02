#!/bin/bash
##############################################
### WELCOME TO MY LANGUAGE LEARNING SCRIPT ###
##############################################

#Sets variable that controls
#if you wanna keep running the script
#after you are done with a session
run="yes"

#Sets the location of the Language files
files=$(ls $(pwd)/words | sed 's/.txt//g' | nl )

#Calculates the amount of correct answers
correct_answers="0"
incorrect_answers="0"

#Welcome message function
welcome() { \

dialog --colors --title "\Z7\ZbLearn Azerbajani!" --msgbox "\Z4Welcome to my script that will help you pratice azerbajani words and sentences\\n\\n-Karl" 16 60

}

#Function that let you choose which file you wanna use
wordstolearn() { \


clear
while [ -z $choice ] ; do
wordtext=$(printf "Choose which list you want to use for learning\nThese files are available:\n$files")
#wordstolearn=$(dialog --colors --title "\Z7\ZbWord list" --inputbox "\Z4$wordtext" --output-fd 1 8 60  ) 

read -p "$wordtext :" wordstolearn

choice=$(printf "\n$files" | grep $wordstolearn | awk '{print $NF}' | sed 's/$/.txt/g')

#if [ -z $choice ] ; then
#
#dialog --colors --title "\Z7\ZbError!" --msgbox "\Z4Invalid value file doesn't exist" 16 60 
#
#fi

done

choice_file=$(cat $(pwd)/words/$choice | sed -e 's/ /_/g' | sort -R)

[ -z $choice_file ] && clear && printf "File is empty exiting" && exit

}

#Function that ask you if you wanna write in English or Azerbajani
azeri_or_english() { \

dialog --colors --title "\Z7\ZbMake a choice" --yes-label "Azerbajan" --no-label "English" --yesno "\Z4Do you want your answers to be written in Azerbajani or English?" 8 60 && language=azerbajan || language=english


}

#Function that will ask you the question
#And determine if you answered correctly or not
question() { \

    for cf in $choice_file ; do
    
        azeri=$(echo $cf | awk -F ":" '{print $1}') 
        eng=$(echo $cf | awk -F ":" '{print $2}') 


    for en in $eng ; do
    for aze in $azeri ; do
    
    if [ $language = "azerbajan" ] ; then  
    word=$(echo $en | sed -e 's/_/ /g')
    question=$(printf "What is $word in Azerbajani?\n")
    correct=$(echo $aze | sed -e 's/_/ /g')
    else
    
    word=$(echo $aze | sed -e 's/_/ /g')
    question=$(printf "What is $word in English?\n")
    
    correct=$(echo $en | sed -e 's/_/ /g')
    fi 
 
    
    answer=$(dialog --colors --title "\Z7\ZbQuestion" --inputbox "\Z4$question" --output-fd 1 8 60  ) 
    

      if [ "$answer" = "$correct" ] ; then
         
          correct_answers=$(expr "$correct_answers" "+" "1") 
         dialog --colors --title "\Z7\ZbCorrect!!" --msgbox "\Z4Congratulations your answer was correct" 16 60
     else
         incorrect_answers=$(expr "$incorrect_answers" "+" "1")
         dialog --colors --title "\Z7\ZbIncorrect!!" --msgbox "\Z4Sadly your answer is incorrect\ncorrect answer is $correct" 16 60

    fi
done
done
done
}

#Function that will ask you if you want to 
#Do another session
wanttotryagain() {


dialog --colors --title "\Z7\ZbRetry?" --yes-label "Yes" --no-label "No" --yesno "\Z4Do you want to try again using another list or same list?" 8 60 && run=yes || run=no

}
     

welcome

while [ $run = "yes" ] ; do

wordstolearn 

azeri_or_english 

question
 


wanttotryagain

choice=""

done

clear

#Will print your correct answers and incorrects answers 
#All sessions combined
echo -e "\e[1;32mCorrect answers : $correct_answers"

echo -e "\e[1;31mIncorrect answers : $incorrect_answers"
