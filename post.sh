#!/bin/bash


create()
{
        while [[ -z "$askType" ]]
        do
                select opt in "Personal Post" "Guild Post"
                do
                        pType=$opt

                        if [[ "$opt" != "Personal Post" ]] && [[ "$post" != "Guild Post" ]]
                        then
                                printf "\nInvalid input.."
                               askType=
                        fi

                        askType="done"
                        break
                done
        done

        printf "\n"
        read -p "Type here: " content
        echo "$content" > temp.txt

        content="@$username: $content"

        date=$(date +"%d-%b-%H-%M")
        printf "\n\n                 ===== Preview: ====="
        printf "\n-----------------------------------------------------\n\n"

        # Made before learning about xargs -n:
        # printf "\n\n@$username:\n"
        # fold -w 40 temp.txt

        echo "$content" | xargs -n 9
        echo -e "\n- posted on: $date"
        printf "\n-----------------------------------------------------\n"

        while [[ -z "$confirm" ]]
        do
                read -p "Everything look good? (Y/n): " confirm
                if [[ "$confirm" = "Y" ]] || [[ "$confirm" = "y" ]]
                then
                        post
                elif [[ "$confirm" = "N" ]] || [[ "$confirm" = "n" ]]
                then
                        while [[ -z "$askAgain" ]]
                        do
                                read -p "Do you still want to post something? (Y/n): " askAgain
                                if [[ "$askAgain" = "Y" ]] || [[ "$askAgain" = "y" ]]
                                then
                                        confirm=
                                        create
                                elif [[ "$askAgain" = "N" ]] || [[ "$askAgain" = "n" ]]
                                then
                                        printf "\nNo problem!"
                                        ./navList.sh
                                else
                                        printf "Invalid input.."
                                        askAgain=
                                fi
                        done
                else
                        printf "Invalid input.."
                        confirm=
                fi
        done
}

post()
{
        content="$content #"
        date="$date @"

        if [[ "$pType" = 'Personal Post' ]]
        then
                c_genID
                guild_id=1
        else
                g_genID
        fi

        psql << EOF
                \connect atahernia

                INSERT INTO envy_content VALUES
                        ($content_id, $account_id, 
                        $guild_id, '$content', 
                        '$date', '$pType'); 
EOF
}

c_genID()
{
content_id=$(( RANDOM % 10 ))

        for i in {1..8}
        do
                rand=$(( RANDOM % 10 ))
                content_id="$content_id""$rand"
        done

        cont_ID_Exists=$(psql -d atahernia -U atahernia -AXqtc "SELECT EXISTS(SELECT content_id FROM envy_content WHERE content_id = '$content_id')")

        if [[ "$cont_ID_Exists" = 't' ]]
        then
                content_id=
                cont_ID_Exists=
                c_genID
        fi
}

printf "\n ================ ENVY: Make a Post! ================ "
printf "\n|                                                    |"
printf "\n|                                                    |"
printf "\n|              Post anything you like!               |"
printf "\n|                                                    |"
printf "\nV                                                    V\n"

create

chmod +x navList.sh
./navList.sh