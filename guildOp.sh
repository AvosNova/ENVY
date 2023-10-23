#!/bin/bash

## Guild Operations

own_Guild=$(psql -AXqtc "SELECT EXISTS(SELECT account_id FROM envy_guilds WHERE account_id = '$account_id')")
in_Guild=$(psql -AXqtc "SELECT EXISTS(SELECT account_id FROM envy_guild_list WHERE account_id = '$account_id')")

g_genID()
{
guild_id=$(( RANDOM % 10 ))

        for i in {1..8}
        do
                rand=$(( RANDOM % 10 ))
                guild_id="$guild_id""$rand"
        done

        guild_ID_Exists=$(psql -AXqtc "SELECT EXISTS(SELECT guild_id FROM envy_guilds WHERE guild_id = '$guild_id')")

        if [[ "$guild_ID_Exists" = 't' ]]
        then
                guild_id=
                guild_ID_Exists=
                g_genID
        fi
}

m_genID()
{
member_id=$(( RANDOM % 10 ))

        for i in {1..8}
        do
                rand=$(( RANDOM % 10 ))
                member_id="$member_id""$rand"
        done

        member_ID_Exists=$(psql -AXqtc "SELECT EXISTS(SELECT member_id FROM envy_guild_list WHERE member_id = '$member_id')")

        if [[ "$member_ID_Exists" = 't' ]]
        then
                member_id=
                member_ID_Exists=
                m_genID
        fi
}

nameExists()
{
        guild_Exists=$(psql -AXqtc "SELECT EXISTS(SELECT guild_name FROM envy_guilds WHERE guild_name = '$joinName')")

        if [[ "$guild_Exists" = 't' ]]
        then
                printf "Already taken! Try another name.."
                read -p "Type a guild name: " joinName
                nameExists
        fi
}

askInput()
{

        while [[ -z "$askIn" ]]
        do
                read -p "Which guild do you want to join: " joinName
                check_name=$(psql -AXqtc "SELECT EXISTS(SELECT guild_name FROM envy_guilds WHERE guild_name ==
 '$joinName')")

                if [[ "$check_name" = 'f' ]]
                then
                        printf "\nSorry this name doesn't exist, try again...\n"
                        check_name=
                        askIn=
                else
                        echo "Great choice!"
                        askIn="done"
                fi
        done

}

if [[ "$own_Guild" = 'f' ]] && [[ "$in_Guild" = 'f' ]]
then
        while [[ -z "$askGuild" ]]
        do
                select opt in "Join Guild" "Create Guild"
                do
                        choice=$opt

                        if [[ "$choice" != "Join Guild" ]] && [[ "$choice" != "Create Guild" ]]
                        then
                               printf "\nInvalid input.."
                               askGuild=
                        else
                               askGuild='asked'
                        fi

                        break
                done
        done
else
        chmod +x guildList.sh
        ./guildList.sh
fi

if [[ "$choice" = "Join Guild" ]]
then
        psql << EOF
                SELECT guild_name FROM envy_guilds;
EOF
        askInput
        echo "1"
        m_genID
        echo "2"
        joinID=$(psql -AXqt --command "SELECT guild_id FROM envy_guilds WHERE guild_name = '$joinName'")
        echo "3"
        member_rank="Tier I"
        echo "4"
        date_joined=$(date +"%d-%b-%H-%M")
        echo "5"
        psql << EOF
                INSERT INTO envy_guild_list VALUES($member_id, '$joinName', $joinID, $account_id, '$member_rank', '$date_joined');
EOF
        printf "\nNice! You are now in $joinName!\n"

else
        printf "\n"
        read -p "Enter a guild name: " joinName
        nameExists
        g_genID
        m_genID
        member_rank="Guild Master"
        date_joined=$(date +"%d-%b-%H-%M")

        psql << EOF
                INSERT INTO envy_guilds VALUES ($guild_id, $account_id, '$joinName');

                INSERT INTO envy_guild_list VALUES($member_id, '$joinName', $guild_id, $account_id, '$member_rank', '$date_joined');
EOF
        printf "\nNice! You are now a Guild Master!\n"
fi

./navList.sh
