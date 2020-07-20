#!/bin/bash

file_name=$1
log_size=$2
current_date=$(date +'%m-%d-%Y')
file_size=$(stat -f %z "$file_name")

rotate() {
    if [ "$file_size" -ge "$log_size" ]
    then
        max_ver="$(getMaxVer)"

        if [[ "$max_ver" -eq "-1"]]
        then
            zip "${file_name}-${current_date}".zip "${file_name}"
        else
            zip "${file_name}-${current_date}".zip "${file_name}"
}

getMaxVer() {
    max=-1
    pattern="${file_name}-${current_date}.zip."

    if 

    for file in $(find . -name "${pattern}*")
    do
        num=${file##pattern}
        [[ "$num" -gt "$max" ]] && $max=$num
    done

    echo $max
}