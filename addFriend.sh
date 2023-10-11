#!/bin/bash

## CONCERNS
## - Issue with updating the list to remove users from list that
##   you are already friends with.

psql <<EOF
         INSERT INTO envy_friends VALUES ('$account_id', '$account_id', '$account_id');
EOF

clear

psql <<EOF
        SELECT name AS "Name", username AS "Username" FROM envy_account_info
        WHERE account_id NOT IN (SELECT friend_id FROM envy_friends WHERE account_id 
        = (SELECT account_id FROM envy_account_info WHERE username = '$username'))
        AND username != '$username';;
EOF

printf "Look through the list of users, is there someone you want to follow?\n"

addFriend()
{
        friend=

        while [ 1 ]
        do
                printf "\n"
                read -p "Y/n: " ans

                while [[ "$ans" == 'Y' ]] || [[ "$ans" == 'y' ]]
                do
                        printf "\n"
                        read -p "Great! Type in their username: " frnduser

                        frndExists
                        genID

                        friend_id=$(psql -d atahernia -AXqtc "SELECT account_id FROM envy_account_info WHERE username = '$frnduser'")

                        psql <<EOF
                                INSERT INTO envy_friends VALUES ('$group_id', '$account_id', '$friend_id');
EOF

                        printf "\nDo you want to follow another user?\n"
                        read -p "Y/n: " ans2

                        if [[ "$ans2" == 'Y' ]] || [[ "$ans2" == 'y' ]]
                        then
                                continue
                        elif [[ "$ans2" == 'N' ]] || [[ "$ans2" == 'n' ]]
                        then
                                break
                        else
                                printf "\nInvalid input, try again..\n"
                                read -p "Y/n" ans
                        fi
                done

                if [[ "$ans" == 'N' ]] || [[ "$ans" == 'n' ]]
                then
                        printf "\nNo problem!\n"
                        break
                elif [[ "$ans" == 'Y' ]] || [[ "$ans" == 'y' ]]
                then
                        break
                else
                        echo "Invalid input, try again..\n"
                fi
        done
}

frndExists()
{
        while [[ "$frnduser" == "$username" ]]
        do
                printf "\nNice try, you can't follow yourself. Try again...\n"
                read -p "Type in their username: " frnduser
        done

        group_Exists=$(psql -d atahernia -U atahernia -AXqtc "SELECT EXISTS(SELECT group_id FROM envy_friends WHERE account_id = (SELECT
        account_id FROM envy_account_info WHERE username = '$username') AND friend_id = (SELECT account_id FROM envy_account_info 
        WHERE username = '$frnduser'))")

        if [[ "$group_Exists" = 't' ]]
        then
                printf "You already follow $frnduser! Try another user.."
                read -p "Type in their username: " frnduser
                frndExists
        fi
}
genID()
{
        group_id=$(( RANDOM % 10 ))

                for i in {1..8}
                do
                        rand=$(( RANDOM % 10 ))
                        group_id="$group_id""$rand"
                done

                group_ID_Exists=$(psql -d atahernia -U atahernia -AXqtc "SELECT EXISTS(SELECT group_id FROM envy_friends WHERE group_id = '$group_id')")

                if [[ "$group_ID_Exists" = 't' ]]
                then
                        group_id=
                        group_ID_Exists=
                        genID
                fi
}

addFriend

./navList.sh
