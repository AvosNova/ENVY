!/bin/bash

## Make ID
f_genID()
{
        finance_id=$(( RANDOM % 10 ))

        for i in {1..8}
        do
                rand=$(( RANDOM % 10 ))
                finance_id="$finance_id""$rand"
        done

        finance_ID_Exists=$(psql -d atahernia -U atahernia -AXqtc "SELECT EXISTS(SELECT finance_id FROM envy_financials WHERE finance_id = '$finance_id')")

        if [[ "$finance_ID_Exists" = 't' ]]
        then
                finance_id=
                finance_ID_Exists=
                f_genID
        fi
}

## Ask to add or check finances
firstTime()
{
        f_genID

        echo -e "\nHow are your finances looking as of today? (Include all assets)"
        read -p "Current assets: " cur_assets

        numReg="^[0-9]+$"
        if [[ ! $cur_assets =~ $numReg ]]
        then
                echo -e "\nPlease enter a number.."
                firstTime
        fi

        echo -e "\nHow does your income look?"

        read -p "Weekly Income: " wek_assets
        while [[ ! $wek_assets =~ $numReg ]]
        do
                printf "\n"
                read -p "Weekly Income: " wek_assets
        done

        mon_assets=$((wek_assets*4))
        anu_assets=$((mon_assets*12))
        financial_score=$((wek_assets*100))

        psql << EOF
                CREATE OR REPLACE VIEW first_vew AS SELECT * FROM envy_financials;

                INSERT INTO first_vew VALUES('$finance_id', '$account_id',
                '$financial_score', '$cur_assets', '$wek_assets', '$mon_assets',
                '$anu_assets');
EOF


printf "\n\nThank you! Your finances have been updated now.."
}

update()
{
        echo -e "\nGreat! How much did you earn today?"
        read -p "Add assets: " add_assets

        cur_assets=$(psql -d atahernia -AXqt --command "SELECT current_finances FROM envy_financials WHERE account_id = '$account_id'")

        total_assets=$((cur_assets+add_assets))
        upload
}

updateOther()
{

        updAll=

        printf "\nDo you need to update your weekly, monthly, and annual income?"
        read -p "(Y/n): " updAll

        if [[ "$updAll" = "Y" ]] || [ "$updAll" = "y" ]
        then
                updateOther
        elif [[ "$updAll" = "N" ]] || [ "$updAll" = "n" ]
        then
                showInfo
        else
                printf "\nInvalid input, try again.."
                updateOther
        fi
}


askNav()
{
        nav=

        select opt in "Update Finances" "Leaderboard" "Navigation Menu"
        do
                nav=$opt

                if [[ "$nav" = "Update Finances" ]]
                then
                        update
                elif [[ "$nav" = "Leaderboard" ]]
                then
                        chmod +x leaderboard.sh
                        ./leaderboard.sh
                elif [[ "$nav" = "Navigation Menu" ]]
                then
                        chmod +x navList.sh
                        ./navList.sh
                else
                        "Invalid input, try again.."
                        askNav
                fi

        done
}

upload()
{
        financial_score=$((total_assets*100))
        psql << EOF
                CREATE OR REPLACE RULE upload_rule
                AS ON UPDATE TO envy_financials
                DO ALSO (UPDATE envy_account_info SET
                financial_score = $financial_score WHERE
                account_id = '$account_id');
        
                UPDATE envy_financials SET current_finances = $total_assets,
                financial_score = $financial_score;

EOF
updateOther
}

showInfo()
{
        psql << EOF
                SELECT name, username, financial_score FROM envy_account_info 
                WHERE account_id = '$account_id';
EOF
askNav
}

isInSystem=$(psql -d atahernia -U atahernia -AXqtc "SELECT EXISTS(SELECT finance_id FROM envy_financials WHERE account_id = '$account_id')")

if [[ "$isInSystem" = 'f' ]]
then
        firstTime
fi

showInfo

read -p "Enter to end"                            