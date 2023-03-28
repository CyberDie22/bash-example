#!/usr/bin/env bash

# get the minimum UID defined in /etc/login.defs
UID_MIN="$(cat /etc/login.defs | grep UID_MIN | grep -Eo '[0-9]+$' | sed '1p;d')"

# get a list of all users with UID >= UID_MIN
USERS="$(getent passwd | cut -d: -f1,3 | awk -F: "\$2>=$UID_MIN" | cut -d$'\n' -f2- | cut -d: -f1)"

# read the list of users into an array
readarray -t <<< $USERS

# prompt the user for the file containing the list of approved users
read -p "Users file: " userfile

while IFS="\n" read -r line; do
    IFS=':' read -a col <<< ${line};
    NAME=${col[0]}
    USER_UID=${col[2]}

    if (( "$USER_UID" > "$UID_MIN" )); then

        echo "checking user: ${NAME}"

        # assume the user is not ok until proven otherwise
        is_ok="no"

        # read the list of approved users from the specified file
        while IFS="\n" read -r line; do

            # ignore the first line of the file (assumed to be a header)
            if [ "$line" != "users" ]; then

                # if the current line matches the current user in the loop,
                # mark the user as approved and print a message indicating that
                if [ "$line" = "$NAME" ]; then
                    echo "user is good"
                    is_ok="yes"
                fi
            fi

        # read from the specified user file
        done < $userfile

        # if the user was not found in the approved list, delete the user
        if [ "$is_ok" = "no" ]; then
            echo "user is not ok: $NAME"
            userdel -r "$NAME"
        fi

    fi
done < /etc/passwd