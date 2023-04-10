#!/usr/bin/env bash


file="file path here people!"
delimiterString='a'
while IFS="\n" read -r line; do
    IFS=$delimiterString 
    read -a col <<< ${line};
    
    DataCol0=${col[0]}
    DataCol1=${col[1]}

    echo "$DataCol0"
    echo "$DataCol1"
done < $file
