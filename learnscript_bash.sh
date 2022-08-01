#!/bin/bash

clear
#sets the path to look for group names
#and it will throw an error if the path doesnt exist
lit_path=$(ls "$(pwd)/words/" | awk '/txt/')
correct='0'
incorrect='0'

[ $? != "0" ] && printf "Path $lit_path Doesn't exist" && exit

lit_lang_path=$(printf '%s\n' "${lit_path[@]}" | nl )
valid_choice=$(printf '%s\n' "${lit_lang_path[@]}" | awk '{print $1}')

#Asks you which group to learn based on folder names
#You will need to add the folders manually with subfolders
read -p "Choose the file you want to practice ?

$lit_lang_path  :"   -a choice

clear
[ -z $choice ] && exit
checkname=$(printf '%s\n' "${valid_choice[@]}" | grep $choice )

proper_lit_name=$(printf '%s\n' "${lit_path[@]}" | grep $choice | awk '{ print $2 }')

[ -z $checkname ] && printf "\nThis is not valid" && exit

word_path=$(cat $lit_path/$proper_lit_name | sort -R  )

for word in $word_path ; do

 random_word=$(printf '%s\n' "${word[@]}" )



 read -p "What is $random_word in lithuanian: ? " -a answer

uppercase=$(echo $answer | grep '[A-Z]')
[ -z $uppercase ] || answer=$(echo $answer | sed 's/[A-Z]/\L&/g')

[ "$answer" = "$random_member" ] && printf "\nYour answer is correct\n" && correct=$(expr $correct + "1")   
[ "$answer" != "$random_member" ] && printf "\nYour answer is incorrect\nCorrect answer is $random_member\n" && incorrect=$(expr $incorrect + "1")

read -p "Press enter to continue: "

clear

done

printf  "Correct $correct\n"
printf  "Incorrect $incorrect\n"



