#!/bin/bash

## Login Script

username=
password=

dotAnim=(... o.. .o. ..o)

waitingInput()
{
        printf "\n"
        while [ 1 ]
        do
                for i in "${dotAnim[@]}"
                do
                        printf "\rPress enter to continue $i "
                        sleep .5
                done
        done
}

login()
{
        echo -e "\n"
        read -p "Username: " username

        prompt="Password: "

        unset password
        unset char_count

        prompt="Password: "

        while IFS= read -p "$prompt" -r -s -n 1 char
        do
                if [[ $char == $'\0' ]]
                then
                        break
                fi

                if [[ $char == $'\177' ]]
                then
                        if [ $char_count -gt 0 ]
                        then
                                char_count=$((char_count-1))
                                prompt=$'\b \b'
                                password="${password%?}"
                        else
                                prompt=''
                        fi
                else
                        char_count=$((char_count+1))
                        prompt='*'
                        password+="$char"
                fi
        done


        userExists=$(psql -d atahernia -U atahernia -AXqtc "SELECT EXISTS(SELECT username FROM envy_accounts WHERE username = '$username' AND password = '$password')")
        if [[ "$userExists" = 't' ]]
        then
                export username
        else
                echo -e "\nIncorrect Username or Password, try again..."
                login
        fi
}

clear

printf "\n ================ ENVY: Login Screen ================"
printf "\n|                                                    |"
printf "\n|                                                    |"
printf "\n|        Enter your login information below:         |"
printf "\nV                                                    V\n"

login

printf "\n\n|                                                    |"
printf "\n|           Welcome back and Good Fortune,           |"
printf "\n|                       ENVY                         |"
printf "\n|                                                    |"
printf "\n ====================================================\n"

waitingInput & pid=$!
read -sp ""
kill $pid

chmod +x profile.sh
./profile.sh