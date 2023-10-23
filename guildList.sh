#!/bin/bash

printf "\nGUILD LIST: \n\n"

psql <<EOF
        SELECT a.name AS "Name", b.member_rank AS "Rank" FROM envy_account_info a,
        envy_guild_list b WHERE a.account_id = b.account_id; 
EOF

./navList.sh