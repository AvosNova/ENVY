#!/bin/bash

## Account Creation Script

## CONCERNS:

username=
password=
region=
hint=

checkPass=

dotAnim=(... o.. .o. ..o)

waitingInput()
{
        while [ 1 ]
        do
                for i in "${dotAnim[@]}"
                do
                        printf "\rPress enter to continue $i "
                        sleep .5
                done
        done
}

askUser()
{
        printf "\n"

        while [[ -z "$username" ]]
        do
                read -p "Enter username: " username
        done

        while [[ "${#username}" -gt 20 ]]
        do
                echo -e "\nPlease keep your username within 20 characters.."
                read -p "Enter username: " username
        done

        userExists=$(psql -AXqtc "SELECT EXISTS(SELECT username FROM envy_accounts WHERE username = '$username')")
        if [[ "$userExists" = 't' ]]
        then
                echo -e "\nThat username already exists, try again..."
                username=
                userExists=
                askUser
        fi
}

askPass()
{
        while [ -z "$password" ]
        do
                read -p "Enter password: " password
        done

        while [[ "${#password}" -gt 20 ]]
        do
                echo -e "\nPlease keep your password within 20 characters.."
                read -p "Enter password: " password
        done


        read -p "Confirm your password: " checkPass
        if [[ "$checkPass" == "$password" ]]
        then
                printf "\n|                    Thank you!                      |"
                printf "\n|      Now just a few more steps to ensure your      |"
                printf "\n|              account stays secure...               |"
                printf "\nV                                                    V\n\n"
                askSecure
        else
                echo -e "\nSorry thats not right, try again..."
                askPass
        fi
}

askSecure()
{
        read -p "Enter your region (your states abbreviation): " region
        while [[ "${#region}" -ne 2 ]]
        do
                echo -e "\nMake sure you only enter 2 characters..."
                read -p "Enter your region (your states abbreviation): " region
        done

        printf "\n|     Great! You're almost done! Please enter a      |"
        printf "\n|      hint to help you remember your password       |"
        printf "\n|              incase you ever forget.               |"
        printf "\nV                                                    V\n\n"

        while [ -z "$hint" ]
        do
               read -p "Hint: " hint
        done

        while [[ "${#hint}" -gt 20 ]]
        do
                echo -e "\nPlease keep your hint within 20 characters.."
                read -p "Enter hint: " hint
        done

}

conclude()
{
        printf "\n\nACCOUNT INFORMATION:\n\n"
        echo -e "Username: $username"
        echo -e "Password: $password"
        echo -e "Region: $region"
        echo -e "Hint: $hint\n"
}

## MOVING ENVY_ACCOUNTS CREATION TO SETUP

clear

printf "\n ============== ENVY: Account Creation =============="
printf "\n|                                                    |"
printf "\n|                                                    |"
printf "\n|               Lets get you started..               |"
printf "\n|                                                    |"
printf "\n|             Follow the prompts below:              |"
printf "\nV                                                    V\n"

askUser
askPass
conclude

printf "\n|    All done! Above is your account information,    |"
printf "\n|    feel free to review. Press enter to confirm     |"
printf "\n|      creation and to go to the login screen.       |"
printf "\n|                                                    |"
printf "\n|                                                    |"
printf "\n|                   Good fortune,                    |"
printf "\n|                       ENVY                         |"
printf "\n|                                                    |"
printf "\n ====================================================\n"

printf "\n"

waitingInput & pid=$!
read -sp ""
kill $pid

psql << EOF

        INSERT INTO envy_accounts VALUES('$username', '$password',
        '$region', '$hint');
EOF

chmod +x login.sh
./login.sh
