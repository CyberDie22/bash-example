#!/usr/bin/env bash
#empty

# prompt the user for the file containing the list of approved users
# read -p "somefile Name: " userfile
delimiterString=':'
while IFS="\n" read -r line; do
    IFS=$delimiterString read -a col <<< ${line};
    DataCol1=${col[0]}
    DataCol2=${col[2]}

    echo "$DataCol1"
    echo "$DataCol2"
done < /etc/passwd