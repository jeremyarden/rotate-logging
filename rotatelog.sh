#!/bin/bash

file_name=$1
log_size=$2
current_date=$(date +'%m-%d-%Y')
file_size=$(stat -f %z "$file_name")

rotate() {
    if [ "$file_size" -ge "$log_size" ]
    then
        zip -v "${file_name%%.*}-${current_date}".zip "$file_name"
    fi
}

getMaxVer() {
    
}

