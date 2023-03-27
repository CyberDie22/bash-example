#!/usr/bin/env bash
# Get the smallest UID that a normal user can have
# grep searches for the provided string in the input
# grep -E uses regular expressions to search
# sed '$LINEp;d' returns the line for line number $LINE
UID_MIN="$(cat /etc/login.defs | grep UID_MIN | grep -Eo '[0-9]+$' | sed '1p;d')"

# Get all users above $UID_MIN
# getent gets the entries from a file
# cut cuts an input on a delimiter (here ':'), and selects only certain columns
# awk is kinda a scriping language for selecting text
USERS="$(getent passwd | cut -d: -f1,3 | awk -F: "\$2>=$UID_MIN" | cut -d$'\n' -f2- | cut -d: -f1)"

# turn list of users into array
readarray -t <<< $USERS

# get user input for file and put it into the 'userfile' variable
read -p "Users file: " userfile


for (( i=0; i<${#MAPFILE[@]}; i++ )); do
    echo "checking user: ${MAPFILE[$i]}"

    is_ok="no"
    while IFS="\n" read -r line; do
        if [ "$line" != "users" ]; then
            if [ "$line" = "${MAPFILE[$i]}" ]; then
                echo "user is good"
                is_ok="yes"
            fi
        fi
    done < $userfile

    if [ "$is_ok" = "no" ]; then
        echo "user is not ok: ${MAPFILE[$i]}"
        userdel -r "${MAPFILE[$i]}"
    fi
done