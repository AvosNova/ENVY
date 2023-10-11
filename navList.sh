#!/bin/bash

## CONCERNS
## - Put options in an array

next()
{
        printf "\n===== Navigation List =====\n\n"
        nextInput=

        while [[ -z "$nextInput" ]]
        do
                select opt in "Profile" "Post" "Friendlist" "Homefeed" "Guildfeed" "Follow Someone" "Other"
                        do
                                nextInput=$opt

                                if [ "$opt" != "Profile" ] && [ "$opt" != "Post" ] && [ "$opt" != "Friendlist" ] && [ "$opt" != "Homefeed" ]  && [ "$opt" != "Guildfeed" ] && [ "$opt" != "Follow Somone" ] && [ "$opt" != "Other" ]
                                then
                                        echo "Invalid Input.."
                                        nextInput=
                                fi

                                if [[ "$opt" = "Profile" ]]
                                then
                                        chmod +x profile.sh
                                        ./profile.sh
                                fi

                                if [[ "$opt" = "Post" ]]
                                then
                                        chmod +x post.sh
                                        ./post.sh
                                fi

                                if [[ "$opt" = "Friendlist" ]]
                                then
                                        chmod +x friendlist.sh
                                        ./friendlist.sh
                                fi

                                if [[ "$opt" = "Homefeed" ]]
                                then
                                        chmod +x homefeed.sh
                                        ./homefeed.sh
                                fi

                                if [[ "$opt" = "Guildfeed" ]]
                                then
                                        chmod +x guildfeed.sh
                                        ./guildfeed.sh
                                fi

                                if [[ "$opt" = "Follow Someone" ]]
                                then
                                        chmod +x addFriend.sh
                                        ./addFriend.sh
                                fi

                                if [[ "$opt" = "Other" ]]
                                then
                                        printf "\n"
                                        other
                                fi

                                break
                        done
        done

}

other()
{
        otherInput=

        while [[ -z "$otherInput" ]]
        do
                select opt in "Finances" "Leaderboard" "Guild Options" "Unfollow" "Edit Account" "Previous" "Log Out"
                        do
                                otherInput=$opt

                                if [ "$opt" != "Finances" ] && [ "$opt" != "Leaderboard" ] && [ "$opt" != "Guild Options" ] && [ "$opt" != "Edit Account" ] && [ "$opt" != "Edit Account" ] && [ "$opt" != "Previous" ] && [ "$opt" != "Log Out" ]
                                then
                                        echo "Invalid Input.."
                                        otherInput=
                                fi

                                if [[ "$opt" = "Finances" ]]
                                then
                                        chmod +x finances.sh
                                        ./finances.sh
                                fi

                                if [[ "$opt" = "Leaderboard" ]]
                                then
                                        chmod +x leaderboard.sh
                                        ./leaderboard.sh
                                fi

                                if [[ "$opt" = "Guild Options" ]]
                                then
                                        chmod +x guildOp.sh
                                        ./guildOp.sh
                                fi

                                if [[ "$opt" = "Unfollow" ]]
                                then
                                        chmod +x unfollow.sh
                                        ./unfollow.sh
                                fi

                                if [[ "$opt" = "Edit Account" ]]
                                then
                                        chmod +x edit.sh
                                        ./edit.sh
                                fi

                                if [[ "$opt" = "Previous" ]]
                                then
                                        printf "\n"
                                        next
                                fi

                                if [[ "$opt" = "Log Out" ]]
                                then
                                        chmod +x logout.sh
                                        ./logout.sh
                                fi

                                break
                        done
        done

}

next