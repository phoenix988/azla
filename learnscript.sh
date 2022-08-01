#!/usr/bin/fish

#Sets the directory the script will look in
set lithuaniandir (pwd)/words


#This will check all the language files you have in $lithuaniandir
#So you can choose which file you want to practice with, you need to make the language file yourself
#adding files to this directory with words makes it readable by this script
set list (ls $lithuaniandir | grep txt | nl ) 

set makethelist ""

for l in $list

    set numberoflines (echo $l  | awk '{print $1}')
    set filename (echo $l  | awk '{print $2}' | sed 's/.txt/ /g')



    set makethelist ( printf '%s\n' "$makethelist [$numberoflines]$filename" )

end

 



#This will give you a prompt and let you choose which file you want to use
#all you options will be visible and you just write a number that match the file you want to use.

read -P "Which file do you want to use? 
$makethelist :"  -a filetouse


#If you type nothing this IF statement will exit the script for you.

[ -z $filetouse  ] && exit


#This will check if you are entering a correct value (a number)
#If you dont this will make sure the script won't run
for l in $list 

    set checkname ( echo $l | awk '{print $1 }' )

    if [ $checkname != $filetouse ]


    else    

     set thisisnotvalid "valid"



    end
end


if [ "$thisisnotvalid" = "valid" ]
 
    echo ""
  

else 


echo "The value isn't a file"
  sleep 2
    exit


end




#This will make sure that the number you choose will be converted into a filename
#That can be read by this script

for l in $list


    set matchingfile ( echo $l | grep $filetouse)
    set matchingline ( echo $matchingfile | awk '{print $1}')  
    set makecorrectname ( echo $matchingfile | awk '{print $2}' ) 


    


    if [ "$matchingline" = "$filetouse" ]


        break

     else 

         echo ""

end
end
    




clear



#This variable will store all the words from the file you want to practice on

set words (cat $lithuaniandir/$makecorrectname | sort -R ) 

set incorrectanswers ( echo " " )


#This will calculate how many correct and incorrect answers you have
set ca (expr 0)
set ica (expr 0)


#This creates the loop that asks you to translate the word from english to lithuanian
for word in $words 


 
    set lithuanian (echo $word | cut -d ':' -f 1 ) 
    set english (echo $word | cut -d ':' -f 2) 
 

for lit in $lithuanian
for eng in $english


read -P "$eng in lithuanian? :" -a "answer"      

        
    
 if [ "$answer" = $lit ] ;

     set mystatus ( echo "correct" )

       echo -e "\e[1;32m$mystatus" 
    
   else 

        set mystatus ( echo "incorrect" )

        echo -e "\e[1;31m$mystatus"
        echo "correct answer is $lit"

#If your answer is null (No value) this makes sure you wont get an error message
#It will redirect the message to /dev/null which is just a black hole
end 2> /dev/null


read -P "Press Enter to continue"
clear

end

end



#This will keep track of how many correct answers you have
if [ $mystatus = "correct" ] ;


    set ca (expr $ca + 1)

else


   set ica (expr $ica + 1)
   set incorrectanswers (echo $incorrectanswers; echo $lit)

end
end


#This will print out the result when you are done 
echo -e "\e[1;32mCorrect answers : $ca"

echo -e "\e[1;31mIncorrect answers : $ica"
