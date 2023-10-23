#!/bin/bash

## Profile script
## CONCERNS
## - Changes made to ER diagram. No address column (location will suffice), no FK on financial score
##   (finances table not created yet, causes confusion)


#while [[ $contentNum != 0 ]]
#do
#        SaveIFS="$IFS"
#        IFS='/EOP//EOP'
#        content=($(psql -d atahernia -AXqt --command "SELECT content FROM envy_content WHERE account_id = '$account_id'"))
#        IFS="$SaveIFS"

#        date=($(psql -d atahernia -AXqt --command "SELECT date FROM envy_content WHERE account_id = '$account_id'"))


#        contentNum=$((contentNum-1))
#        contentArry+=("$content")
#        dateArry+=("$date")
#done

#        SaveIFS="$IFS"
#        IFS=':'
#        date=($(psql -d atahernia -AXqt --command "SELECT date FROM envy_content WHERE account_id = '$account_id'"))
#        IFS="$SaveIFS"


clear

## MOVING ENVY_ACCOUNT_INFO TO SETUP


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

firstTime()
{ 
        ##MOVING ENVY_FRIENDS TO SETUP

        genID
        financial_score='0'

        echo -e "\nWhats your name?"
        read -p "Name: " name

        if [[ "$name" == "" ]]
        then
                echo -e "\nNo name? No problem, tell us a bit yourself.."
                read -p "Bio: " bio
        else
                echo -e "\nNice to meet you $name ! Tell us a bit yourself.."
                read -p "Bio: " bio
        fi

        echo -e "\nWhat is your relationship status?"

        while [[ -z "$relationship" ]]
        do
                select opt in "Taken" "Single" "Other"
                        do
                                relationship=$opt

                                if [ "$opt" != "Taken" ] && [ "$opt" != "Single" ] && [ "$opt" != "Other" ]
                                then
                                        echo "Invalid Input.."
                                        relationship=
                                fi
                                break
                        done
        done


        echo -e "\nWhere are you going/did you go for education?"
        read -p "Education: " education

        echo -e "\nWhat do you do for a living?"
        read -p "Occupation: " occupation

        echo -e "\nWhat are some goals you have?"
        read -p "Goals: " goals

        echo -e "\nWhere can your friends meet you?"
        read -p "Address: " address

        psql <<EOF
                INSERT INTO envy_account_info (account_id, username, financial_score, name, address, occupation,
                 education, relationship, goals, bio) VALUES('$account_id', '$username', $financial_score, '$name', 
                '$address', '$occupation', '$education', '$relationship', '$goals', '$bio');
EOF
}

genID()
{
account_id=$(( RANDOM % 10 ))

        for i in {1..8}
        do
                rand=$(( RANDOM % 10 ))
                account_id="$account_id""$rand"
        done

        acct_ID_Exists=$(psql -AXqtc "SELECT EXISTS(SELECT account_id FROM envy_account_info WHERE account_id = '$account_id')")

        if [[ "$acct_ID_Exists" = 't' ]]
        then
                account_id=
                acct_ID_Exists=
                genID
        fi
}

clear

contentArry=()
dateArry=()

isInSystem=$(psql -AXqtc "SELECT EXISTS(SELECT account_id FROM envy_account_info WHERE username = '$username')")

if [[ "$isInSystem" = 'f' ]]
then
        printf "\n =============== ENVY: Make it yours! =============== "
        printf "\n|                                                    |"
        printf "\n|                                                    |"
        printf "\n|           Since this is your first time            |"
        printf "\n|        lets get to know eachother a bit...         |"
        printf "\n|                                                    |"
        printf "\n|       If you dont want to answer a question        |"
        printf "\n|     just press enter on a clear input to skip!     |"
        printf "\n|                                                    |"
        printf "\n|                                                    |"
        printf "\nV                                                    V\n\n"

        firstTime

        printf "\n|                                                    |"
        printf "\n|       Thanks for taking the time to fill out       |"
        printf "\n|       your info! Press enter to continue to        |"
        printf "\n|                  your profile...                   |"
        printf "\n|                                                    |"
        printf "\n ====================================================\n"

        waitingInput & pid=$!
        read -sp ""
        kill $pid

        ./profile.sh
        exit
        # MAY HAVE TO CLOSE OR BREAK
fi

account_id=$(psql -AXqtc "SELECT account_id FROM envy_account_info WHERE username = '$username'")
financial_score=$(psql -AXqtc "SELECT financial_score FROM envy_account_info WHERE username = '$username'")
name=$(psql -AXqtc "SELECT name FROM envy_account_info WHERE username = '$username'")
address=$(psql -AXqtc "SELECT address FROM envy_account_info WHERE username = '$username'")
occupation=$(psql -AXqtc "SELECT occupation FROM envy_account_info WHERE username = '$username'")
education=$(psql -AXqtc "SELECT education FROM envy_account_info WHERE username = '$username'")
relationship=$(psql -AXqtc "SELECT relationship FROM envy_account_info WHERE username = '$username'")
goals=$(psql -AXqtc "SELECT goals FROM envy_account_info WHERE username = '$username'")
bio=$(psql -AXqtc "SELECT bio FROM envy_account_info WHERE username = '$username'")

#content=$(psql -d atahernia -AXqt --command "SELECT content FROM envy_content WHERE account_id = '$account_id'")
#date=$(psql -d atahernia -AXqt --command "SELECT date FROM envy_content WHERE account_id = '$account_id' AND content_id =
#(SELECT content_id FROM envy_content WHERE content = '$content')")
                                                                    
contentNum=$(psql -AXqt --command "SELECT COUNT(content) FROM envy_content WHERE account_id = '$account_id'")


export account_id

echo -e "Wont be part of the program Account ID = $account_id\n"

printf "\n ================ ENVY: Profile Page ================"
printf "\n|                                                    "
printf "\n|    $name @$username                                "
printf "\n|                                                    "
printf "\n|    Address: $address                               "
printf "\n|    Relationship Status: $relationship              "
printf "\n|                                                    "
printf "\n|    Job: $occupation                                "
printf "\n|    Score: $financial_score                         "
printf "\n|    Education: $education                           "
printf "\n|                                                    "
printf "\n|    Goals: $goals                                   "
printf "\n|    Bio:  $bio                                      "
printf "\n ----------------------------------------------------"
printf "\n|                                                    "
printf "\n|     POSTS:                                         "
printf "\n|----------------------------------------------------\n"

declare -a contentArry=()
declare -a dateArry=()


IFS="#"
contentArry=($(psql -AXqt --command "SELECT content FROM envy_content WHERE account_id = '$account_id'"))

IFS="@"
dateArry=($(psql -AXqt --command "SELECT date FROM envy_content WHERE account_id = '$account_id'"))

for (( i=0; i<$((contentNum));i++ ))
do
        printf "%s\n\n       ${contentArry[$i]}" |xargs -n 9
        printf "%s ~ posted on: ${dateArry[$i]}\n\n"
done

printf "\n   --- Press enter to open the navigation list ---\n\n"

waitingInput & pid=$!
read -sp ""

kill $pid
chmod +x navList.sh
./navList.sh
