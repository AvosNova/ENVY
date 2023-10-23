#!/bin/bash

## Execution of Envy

### CONCERNS: 
### - waitingInput animation does not clear when user puts wrong input
### - occasional UI bug, happens mostly when file is edited
### - carriage return (/r) on animation causes cursor to stick to the same line
###   and to users input

clear

dotAnim=(... o.. .o. ..o)

waitingInput()
{
        while [ 1 ]
        do
                for i in "${dotAnim[@]}"
                do
                        printf "\rWaiting for input $i "
                        sleep .5
                done
        done
}

askInput()
{
        printf "\n"
        select opt in "Login" "Create an Account"
                do
                        result=$opt

                        if [ "$opt" != "Login" ] && [ "$opt" != "Create an Account" ]
                        then
                                echo "Invalid Input.."
                                askInput
                                break
                        fi

                        kill $pid
                        break
                done
}

printf "\n ======================= ENVY ======================="
printf "\n|                                                    |"
printf "\n|                                                    |"
printf "\n|                 Welcome to ENVY,                   |"
printf "\n|           Login or Create an Account...            |"
printf "\n|                                                    |"
printf "\n|           Enter 1 to Login                         |"
printf "\n|           Enter 2 to Create an Account             |"
printf "\n|                                                    |"
printf "\nV                                                    V"

printf "\n"
waitingInput & pid=$!
printf "\n"
askInput

if [[ "$result" == "Login" ]]
then
        chmod +x login.sh
        ./login.sh
        # MAY HAVE TO CLOSE FILE
else
        chmod +x createAcct.sh
        ./createAcct.sh
        # MAY HAVE TO CLOSE FILE
fi