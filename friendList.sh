#!/bin/bash

printf "\nFRIEND LIST: \n\n"

psql <<EOF
        SELECT name AS "Name", username AS "Username" FROM envy_account_info
        WHERE account_id IN (SELECT friend_id FROM envy_friends WHERE account_id 
        = (SELECT account_id FROM envy_account_info WHERE username = '$username'))
        AND username != '$username';;
EOF

./navList.sh