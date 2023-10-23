#!/bin/bash

printf "\n              HomeFeed\n"
printf "___________________________________\n\n"

declare -a contentArry=()
declare -a datearry=()

contentNum=$(psql -AXqt --command "SELECT COUNT(content) FROM envy_content WHERE account_id = '$account_id'")

IFS="#"
contentArry=($(psql -AXqt --command "SELECT content FROM envy_content"))

IFS="@"
dateArry=($(psql -AXqt --command "SELECT date FROM envy_content"))

for (( i=0; i<$((contentNum));i++ ))
do
        printf "%s\n\n       ${contentArry[$i]}" |xargs -n 9
        printf "%s ~ posted on: ${dateArry[$i]}\n\n"
done

chmod +x navList.sh
./navList.sh
